# Example usage:
import logging
import random
import time
from collections import defaultdict

from gate.menu_generator.menu_builder import run_experiments
from rich import print
from rich.logging import RichHandler
from tqdm.auto import tqdm

from kubejobs.experiments.pvc_status import PVCStatus, get_pvc_status
from kubejobs.jobs import (
    KubernetesJob,
    create_jobs_for_experiments,
    create_pvc,
)
from kubejobs.useful_single_liners.count_gpu_usage_general import (
    count_gpu_usage,
)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
handler = RichHandler(markup=True)
handler.setFormatter(logging.Formatter("%(message)s"))
logger.addHandler(handler)

gpu_type_to_max_count = {
    "NVIDIA-A100-SXM4-80GB": 32,
    "NVIDIA-A100-SXM4-40GB": 88,
}


def get_gpu_type_to_use():
    active_gpus = count_gpu_usage()["Available"]
    available_gpu_types = []

    for key, value in active_gpus.items():
        if key in gpu_type_to_max_count:
            remaining_gpu_count = gpu_type_to_max_count[key] - value
            if remaining_gpu_count > 0:
                available_gpu_types.append(key)

    return (
        random.choice(available_gpu_types)
        if len(available_gpu_types) > 0
        else None
    )


env_vars = {
    "NEPTUNE_API_TOKEN": "eyJhcGlfYWRkcmVzcyI6Imh0dHBzOi8vYXBwLm5lcHR1bmUuYWkiLCJhcGlfdXJsIjoiaHR0cHM6Ly9hcHAubmVwdHVuZS5haSIsImFwaV9rZXkiOiJkOTFjMTY5Zi03ZGUwLTQ4ODYtYWI0Zi1kZDEzNjlkMGI5ZjQifQ==",
    "NEPTUNE_PROJECT": "MachineLearningBrewery/gate-exp-0-8-6",
    "NEPTUNE_ALLOW_SELF_SIGNED_CERTIFICATE": "TRUE",
    "WANDB_API_KEY": "821661c6ee1657a2717093701ab76574ae1a9be0",
    "WANDB_ENTITY": "machinelearningbrewery",
    "WANDB_PROJECT": "gate-0-8-12",
    "KAGGLE_USERNAME": "antreasantoniou",
    "KAGGLE_KEY": "d14aab63e71334cfa118bd5251bf85da",
    "PYTEST_DIR": "/data/",
    "EXPERIMENT_NAME": "gate-0-8-12",
    "HF_USERNAME": "Antreas",
    "HF_TOKEN": "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",
    "HF_CACHE_DIR": "/data/",
    "TOKENIZERS_PARALLELISM": "false",
    "CODE_DIR": "/app/",
    "PROJECT_DIR": "/app/",
    "EXPERIMENT_NAME_PREFIX": "gate-0-8-12",
    "EXPERIMENTS_DIR": "/data/experiments/",
    "EXPERIMENT_DIR": "/data/experiments/",
    "DATASET_DIR": "/data/",
    "MODEL_DIR": "/data/model/",
}


pvc_dict = get_pvc_status()


experiment_dict = run_experiments(
    prefix="systest",
    experiment_type="all",
    accelerate_launch_path="/opt/conda/envs/main/bin/accelerate-launch",
    gate_run_path="/app/gate/run.py",
    seed_list=[7],
    print_commands=True,
)


# A summary of the GPU setup is:

# * 32 full Nvidia A100 80 GB GPUs
# * 88 full Nvidia A100 40 GB GPUs
# * 14 MIG Nvidia A100 40 GB GPUs equating to 28 Nvidia A100 3G.20GB GPUs
# * 20 MIG Nvidia A100 40 GB GPU equating to 140 A100 1G.5GB GPUs

# Total A100s in varying configurations: 136.

# Initialize a dictionary to keep track of PVC usage
pvc_usage = defaultdict(int)

total_pvc_count = 50

experiment_dict = list(experiment_dict.items())
# Shuffle the list
random.shuffle(experiment_dict)

# Create a new dictionary from the shuffled list
experiment_dict = dict(experiment_dict)

# experiment_dict = {
#     key: value for key, value in experiment_dict.items() if "winogr" not in key
# }


print(
    f"Total number of commands: {len(experiment_dict)}, each needs 1 GPU hour, so total GPU hours: {len(experiment_dict)}"
)

# for i in range(total_pvc_count):
#     pvc_name = f"gate-pvc-{i}"
#     pvc_name = create_pvc(
#         pvc_name=pvc_name, storage="4Ti", access_modes="ReadWriteOnce"
#     )
job_succesfully_launched = False
idx = 0
experiment_list = list(experiment_dict.items())
while idx < len(experiment_dict.items()):
    pvc_dict: PVCStatus = get_pvc_status()
    while len(pvc_dict.available) == 0:
        pvc_dict: PVCStatus = get_pvc_status()
        time.sleep(2)

    # Select the PVC that has been used the least number of times
    pvc_name = min(pvc_dict.available, key=lambda pvc: pvc_usage[pvc])
    pvc_dict.available.remove(pvc_name)
    pvc_dict.in_use.append(pvc_name)

    # Increment the usage count for the selected PVC
    pvc_usage[pvc_name] += 1
    gpu_type = None
    while gpu_type is None:
        gpu_type = get_gpu_type_to_use()
        job_succesfully_launched = False

    while not job_succesfully_launched:
        name, command = experiment_list[idx]

        # if "fs" in name:
        #     gpu_type = "NVIDIA-A100-SXM4-80GB"

        job = KubernetesJob(
            name=f"{name}".lower(),
            image="ghcr.io/antreasantoniou/gate:latest",
            command=["/bin/bash", "-c", "--"],
            args=[f"{command}"],
            gpu_type="nvidia.com/gpu",
            gpu_product=gpu_type,
            gpu_limit=1,
            backoff_limit=4,
            volume_mounts={
                "gate-disk": {
                    "pvc": pvc_name,
                    "mountPath": "/data/",
                },
            },
            env_vars=env_vars,
            job_deadlineseconds=3600 * 2 * 1,
            ram_request="80G",
            cpu_request=16,
        )

        job_yaml = job.generate_yaml()
        print(
            f"Attemping to launch job {name} on {gpu_type} with PVC {pvc_name}"
        )
        result = 1
        try:
            result = job.run()
            job_succesfully_launched = result == 0
        except Exception as e:
            logger.info(f"Job {name} failed with error: {e}")
        idx += 1
        print(f"Result: {result}")

    time.sleep(2)
