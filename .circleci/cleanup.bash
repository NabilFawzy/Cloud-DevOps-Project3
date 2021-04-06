cleanup () {
  stacks=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE --query "StackSummaries[?starts_with(StackName, \`$2\`) == \`true\`].StackName" --output text --region $1)
  for stack in $stacks
  do
    echo "${stack}: cleaning up change sets"
    changesets=$(aws cloudformation list-change-sets --stack-name $stack --query 'Summaries[?Status==`FAILED`].ChangeSetId' --output text --region $1)
    for changeset in $changesets
    do
      echo "${stack}: deleting change set ${changeset}"
      aws cloudformation delete-change-set --change-set-name ${changeset} --region $1
    done
  done
}