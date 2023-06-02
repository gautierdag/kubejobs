#!/bin/bash
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-in1k-clip_vit_base16_224-42 model=clip-classification  dataset=imagenet1k-classification trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-in1k-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=imagenet1k-classification trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-in1k-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=imagenet1k-classification trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-c100-clip_vit_base16_224-42 model=clip-classification  dataset=cifar100 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-c100-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=cifar100 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-c100-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=cifar100 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-f101-clip_vit_base16_224-42 model=clip-classification  dataset=food101 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-f101-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=food101 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-f101-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=food101 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-stl10-clip_vit_base16_224-42 model=clip-classification  dataset=stl10 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-stl10-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=stl10 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-stl10-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=stl10 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-svhn-clip_vit_base16_224-42 model=clip-classification  dataset=svhn trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-svhn-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=svhn trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-svhn-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=svhn trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-p365-clip_vit_base16_224-42 model=clip-classification  dataset=places365 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-p365-laion_vit_base16_224-42 model=timm-classification model.timm_model_name=vit_base_patch16_clip_224.laion2b dataset=places365 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2;
accelerate launch --mixed_precision=bf16 --gpu_ids=0 gate/run.py exp_name=debug-p365-witp-base16-wit-42 model=tali-classification model.model_repo_path=Antreas/witp-base16-wit-224-42 dataset=places365 trainer=image_classification evaluator=image_classification seed=42 train_batch_size=128 eval_batch_size=128 train_iters=10 learner.evaluate_every_n_steps=5 learner.limit_val_iters=2