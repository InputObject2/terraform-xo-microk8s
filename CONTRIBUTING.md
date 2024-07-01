# Contributing to the Project

We appreciate your interest in contributing to our project! To ensure a smooth and consistent contribution process, please follow these guidelines.

## Pull Request Guidelines

### Conventional Commits

- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for your PR titles. This helps us automate versioning and changelog generation.
- Examples of Conventional Commit messages:
  - `feat: add new feature to module`
  - `fix: resolve issue with deployment script`
  - `docs: update documentation for new feature`
  - `chore: update dependencies`

### Updating Documentation

- Before submitting a PR, make sure to update the Terraform documentation.
- Run the following command to generate the documentation and update the `README.md` file:
  ```bash
  terraform-docs markdown . --output-file README.md
  ```

## Development Workflow

1. **Fork the Repository**: Create a fork of the repository to work on your changes.
2. **Clone Your Fork**: Clone your forked repository to your local machine.
```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

3. **Create a Branch**: Create a new branch for your feature or bugfix.
```bash
git checkout -b feat/your-feature-name
```

4. **Make Changes**: Implement your changes in the new branch.
5. **Commit Changes**: Commit your changes using a Conventional Commit message.
```bash
git add .
git commit -m "feat: add new feature to module"
```

6. **Update Documentation**: Run terraform-docs to update the README.md file.
```bash
terraform-docs markdown . --output-file README.md
```

7. **Push Changes**: Push your branch to your forked repository.
```bash
git push origin feat/your-feature-name
```

8. **Open a Pull Request**: Open a PR to the main repository. Make sure your PR title follows the Conventional Commits guidelines.

## Code Review
Your PR will be reviewed by one of the maintainers. Please be responsive to feedback and be prepared to make adjustments to your code.
Once approved, your PR will be merged into the main branch.

## Thank You
Thank you for contributing to our project! Your support and contributions are greatly appreciated.