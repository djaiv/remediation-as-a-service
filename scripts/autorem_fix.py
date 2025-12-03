import re
import pathlib

tf_path = pathlib.Path("terraform/main.tf")
tf = tf_path.read_text()

# 1) Fix public container access
# Any of:
#   container_access_type = "blob"
#   container_access_type = "container"
# becomes:
#   container_access_type = "private"
tf = re.sub(
    r'container_access_type\s*=\s*"(blob|container)"',
    'container_access_type = "private"',
    tf,
)

# 2) Fix NSG rule that allows RDP 3389 from any

# 2a) Change access from Allow to Deny for the rdp-anywhere rule
tf = re.sub(
    r'(security_rule\s*{[^}]*name\s*=\s*"rdp-anywhere"[^}]*access\s*=\s*")Allow(")',
    r'\1Deny\2',
    tf,
    flags=re.S,
)

# 2b) Change source_address_prefix from * to VirtualNetwork
tf = re.sub(
    r'(security_rule\s*{[^}]*destination_port_range\s*=\s*"3389"[^}]*source_address_prefix\s*=\s*")\*(")',
    r'\1VirtualNetwork\2',
    tf,
    flags=re.S,
)

tf_path.write_text(tf)
print("Auto remediation applied: storage container access set to private and RDP rule restricted.")
