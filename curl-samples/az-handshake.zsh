# Non-interactive login with service principal (if you have one)
# az login --service-principal -u <app-id> -p <password-or-cert> --tenant 97d0ab7f-638f-406d-9aed-2bd5a4b10b91

# For username/password non-interactive login
# az login -u <username> -p <password> --tenant 97d0ab7f-638f-406d-9aed-2bd5a4b10b91

# Or with the current implementation but adding --no-wait to reduce interactive prompts
az login --tenant 97d0ab7f-638f-406d-9aed-2bd5a4b10b91 --no-wait
az account set --subscription "0386dad8-3438-4644-a2b5-01de5c10378d"



