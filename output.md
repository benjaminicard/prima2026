| Scenario | Act | Rule | deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 | attempt evade | uti (pBelief) | uti (env) | events (pBelief) | events (env) |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| s1 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | imp | perm | False | -3 | -3 | harm(q,p,uncoveredLie) | harm(q,p,uncredibleStatement) |
| s2 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | imp | True | 0 | -6 | evade(p,q) | harm(q,p,failedEvade), harm(q,p,uncredibleStatement) |
| s3 | inform(at(r,cemetery)) | erroneous_lie | imp | perm | perm | imp | imp | False | -3 | -4 | harm(q,p,uncoveredLie) | kill(q,p,r) |
| s4 | silence(p,q,0) | ---- | perm | ---- | ---- | imp | ---- | False | -3 | -3 | harm(q,p,refusedToAnswer) | harm(q,p,refusedToAnswer) |
| s5 | inform(at(r,family)) | erroneous_truth | imp | imp | imp | imp | perm | False | -4 | -3 | kill(q,p,r) | harm(q,p,uncoveredLie) |
