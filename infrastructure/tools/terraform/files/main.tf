terraform {
    # source (https://registry.terraform.io/providers/bpg/proxmox/latest/docs)

    backend "s3" {
        # set AWS access key: export AWS_ACCESS_KEY_ID=mykey
        # set AWS secret access key: export AWS_SECRET_ACCESS_KEY=AAAA...

        bucket = "ryanbyrne30-homelab-config" 
        key = "terraform/.tfstate"
        region = "us-west-1" 
    }
}
