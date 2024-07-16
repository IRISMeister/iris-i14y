docker compose exec mailserver setup email add bot@foo.example.com pass
docker compose exec mailserver setup email add foo@foo.example.com pass
docker compose exec mailserver setup email add root@foo.example.com pass
docker compose exec mailserver setup email list
