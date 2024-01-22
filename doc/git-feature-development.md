# Neues Feature entwickeln

`master` ist hier in der Abbildung `main` genannt.

Neue Feature Branch die alle Kommunen betreffen, gehen von `master` ab.
Der Branchname enthält unter anderem die Jira Ticket ID `feature/QPB-1234-new-form-submission`.

## develop feature and deploy to staging server

```mermaid
---
title: develop and deploy to old staging server
---
%%{init: { 'themeVariables':{'git0':'#0000ff', 'git1':'#ff0000', 'git2':'#ffff00'}} }%%
gitGraph
    branch "release/int/development" order: 3
    commit
    checkout "main"
    commit
    branch "feature/SVA-1233-new-a"
    commit
    checkout "main"
    commit
    branch "feature/SVA-1234-new-b"
    commit
    commit
    checkout "release/int/development"
    merge "feature/SVA-1234-new-b" tag: "Deploy to old staging server"
    checkout "main"
    checkout "feature/SVA-1233-new-a"
    commit
```

## Deploy to production servers by gitlab

```mermaid
---
title: deploy to production by gitlab
---
%%{init: { 'themeVariables':{'git0':'#0000ff', 'git1':'#ff0000', 'git2':'#808080'}} }%%
gitGraph
    checkout "main"
    branch "saas" order: 5
    commit
    checkout "main"
    branch "releases" order: 4
    commit
    checkout "main"
    commit
    commit
    branch "feature/QPB-1234-new-form-submission"
    commit
    commit
    checkout "main"
    merge "feature/QPB-1234-new-form-submission" tag: "Pull Request und deploy zu production"
    commit
    checkout "releases"
    merge "main" tag: "Deploy to old production servers"
    checkout "main"
    checkout "saas"
    merge "main" tag: "Deploy to saas production"
```
