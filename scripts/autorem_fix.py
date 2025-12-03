
import re, pathlib

tf_path = pathlib.Path("terraform/main.tf")
tf = tf_path.read_text()

# Fix 1: allow_blob_public_access = true -> false
tf = re.sub(r'allow_blob_public_access\s*=\s*true', 'allow_blob_public_access = false', tf)

# Fix 2: Replace permissive RDP rule with restricted or deny
before = (
    'name                       = "rdp-anywhere"\n'
    '    priority                   = 100\n'
    '    direction                  = "Inbound"\n'
    '    access                     = "Allow"\n'
    '    protocol                   = "Tcp"\n'
    '    source_port_range          = "*"\n'
    '    destination_port_range     = "3389"\n'
    '    source_address_prefix      = "*"\n'
    '    destination_address_prefix = "*"'
)

after = (
    'name                       = "rdp-restricted"\n'
    '    priority                   = 100\n'
    '    direction                  = "Inbound"\n'
    '    access                     = "Deny"\n'
    '    protocol                   = "Tcp"\n'
    '    source_port_range          = "*"\n'
    '    destination_port_range     = "3389"\n'
    '    source_address_prefix      = "VirtualNetwork"\n'
    '    destination_address_prefix = "VirtualNetwork"'
)

tf = tf.replace(before, after)

tf_path.write_text(tf)
print("Auto-remediation applied.")
