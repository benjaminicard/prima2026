# Scénario s1 
## Actions :silence(p,q)silence(p,q)
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |

# Scénario s2 
## Actions :inform(at(r,madrid))silence(p,q)
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |

# Scénario s3 
## Actions :inform(at(r,madrid))silence(p,q)
 ## Attempt evade : True 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |

# Scénario s4 
## Actions :inform(at(r,cemetery))
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,cemetery)) | erroneous_lie | imp | perm | perm | perm | imp |

# Scénario s5 
## Actions :inform(at(r,madrid))inform(at(r,cemetery))
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |
| 1 | inform(at(r,cemetery)) | erroneous_lie | imp | perm | perm | perm | imp |

# Scénario s6 
## Actions :inform(at(r,madrid))inform(at(r,cemetery))
 ## Attempt evade : True 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |
| 1 | inform(at(r,cemetery)) | erroneous_lie | imp | perm | perm | perm | imp |

# Scénario s7 
## Actions :inform(at(r,family))
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,family)) | erroneous_truth | imp | imp | imp | imp | imp |

# Scénario s8 
## Actions :inform(at(r,madrid))inform(at(r,family))
 ## Attempt evade : False 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |
| 1 | inform(at(r,family)) | erroneous_truth | imp | imp | imp | imp | perm |

# Scénario s9 
## Actions :inform(at(r,family))inform(at(r,madrid))
 ## Attempt evade : True 

| Degre | Act | Rule |deontologism | principialism1 | principialism2 | consequentialism1 | consequentialism2 |
| :---------------:| :---------------: | :---------------: | :-----: | :-----: | :-----: | :-----: | :-----: |
| 1 | inform(at(r,family)) | erroneous_truth | imp | imp | imp | imp | perm |
| 0 | inform(at(r,madrid)) | objective_lie | imp | perm | perm | perm | perm |

