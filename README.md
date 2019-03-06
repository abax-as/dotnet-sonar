# dotnet-sonar
.NET Core SDK with Sonar Scanner for MS Build and all dependencies.

The combined container has the .NET Core version of the Sonar Scanner for MS Build. The scanner can be used by running:

```
dotnet sonarscanner begin /k:"project-key"
dotnet build
dotnet sonarscanner end
```

Use the following instead of the `dotnet:2.2-sdk` in your Dockerfile:

`abax/dotnet-sonar:2.2`

This container also contains the `dotnet test` trx output file parser to convert test results to JUnit format, so you can use it for CI servers that support JUnit output.

Original repository for the parser: https://github.com/gfoidl/trx2junit

Example usage, using GitLab CI variable:

```
find ./tests/**/*Tests.csproj | xargs -I{} dotnet test {} -l:trx -r:$CI_PROJECT_DIR/results
trx2junit ./results/*.trx
```