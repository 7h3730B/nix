#!/usr/bin/env python

from github import Github
import requests
import json
import sys
import os

# TODO: maybe add star backup
def get_gitea_session(token):
    session = requests.Session() # Gitea
    session.headers.update({
            "Content-type"  : "application/json",
            "Authorization" : "token {0}".format(token),
    })
    return session

def github_user_repos(gh):
    return gh.get_user().get_repos()

def backup_repo(gitea_url, gitea_user, github_user, github_token, session, repo):
    r = session.get("{0}/users/{1}".format(gitea_url, gitea_user))
    if r.status_code != 200:
        print("Cannot get user id for '{0}'".format(gitea_user), file=sys.stderr)
        exit(1)

    gitea_uid = json.loads(r.text)["id"]

    m = {
        "repo_name"         : "{0}".format(repo.full_name.split('/')[1]),
        "description"       : (repo.description or "not really known")[:255],
        "clone_addr"        : repo.clone_url,
        "mirror"            : True,
        "private"           : repo.private,
        "fork"              : repo.fork,
        "uid"               : gitea_uid,
    }

    if repo.private:
        m["auth_username"]  = github_user
        m["auth_password"]  = "{0}".format(github_token)

    jsonstring = json.dumps(m)

    r = session.post("{0}/repos/migrate".format(gitea_url), data=jsonstring)
    if r.status_code != 201:            # if not CREATED
        if r.status_code == 409:        # repository exists
            return
        print(r.status_code, r.text, jsonstring)

def run ():
    gitea_api_url = os.getenv("GITEA_API_URL");
    gitea_user = os.getenv("GITEA_USER");
    gitea_token = open(os.path.expanduser(os.getenv("GITEA_TOKEN"))).read().strip()

    github_user = os.getenv("GITHUB_USER");
    github_token = open(os.path.expanduser(os.getenv("GITHUB_TOKEN"))).read().strip()

    gh = Github(github_token)
    session = get_gitea_session(gitea_token);

    user_repos = github_user_repos(gh)
    for repo in user_repos:
        backup_repo(gitea_api_url, gitea_user, github_user, github_token, session, repo)
    exit(1)

if __name__ == '__main__':
    run()
