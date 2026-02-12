customer_name = "test-company"
environment   = "dev"
instance_type = "t3.small"

# Spot Instance (ประหยัดค่าใช้จ่าย 70-90%)
use_spot_instance = true
spot_max_price    = "0.02" # Maximum $0.02/hour (ปกติ t3.small ~$0.0208/hr)
# spot_max_price = ""      # ใช้ on-demand price (แนะนำ)
spot_type = "one-time" # หรือ "persistent"
