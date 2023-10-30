function delete_failed_pods_with_string_in_name
    kubectl get pods -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{": status="}{.status.phase}{end}' | grep Failed | grep $argv[1] | awk -F': status=' '{print $1}' | xargs kubectl delete pod
end