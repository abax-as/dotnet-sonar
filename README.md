# dotnet-sonar
.NET Core SDK with Sonar Scanner for MS Build and all dependencies.

The combined container has the .NET Core version of the Sonar Scanner for MS Build. The scanner can be used by running:

```
dotnet sonarscanner begin /k:"project-key"
dotnet build
dotnet sonarscanner end
```

Use the following instead of the `dotnet:2.1-sdk` in your Dockerfile:

`abax/dotnet-sonar`
