# Stream:zen backend

## Installation

```bash
yarn install
```

## Prisma setup

```bash
npx prisma migrate dev
```

## Running the app

```bash
# development
yarn run start

# watch mode
yarn run start:dev

# production mode
yarn run start:prod
```

> [!IMPORTANT]
> When you want to run the app locally and connect to the RDS database and S3 bucket, you need to set the environment variables in the shell you are running the app from. You can use the access keys from the AWS access portal under the project's permission set (with session token).

## Test

```bash
# unit tests
$ yarn run test

# e2e tests
$ yarn run test:e2e

# test coverage
$ yarn run test:cov
```

## License

Nest is [MIT licensed](LICENSE).
