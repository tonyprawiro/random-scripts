echo 'project = "Projet Name" and status = Open and issuetype = "IssueType" and ("Request Type" = "my-request-type")' \
  | python -c 'import sys,urllib;print urllib.quote(sys.stdin.read().strip())'

  curl \
    -u username:secret \
    -X GET \
    -H "Content-Type: application/json" \
    https://www.domain.com/jira/rest/api/2/search?jql=project%20%3D%20%22MyProject%22%20and%20status%20%3D%20Open%20and%20issuetype%20%3D%20%22MyIssueType%22%20and%20%28%22Request%20Type%22%20%3D%20%22my-issue-type1%22%20or%20%22Request%20Type%22%20%3D%20%22my-issue-type2%22%29
