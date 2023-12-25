locals {
  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
      write_files = [
        {
          path        = "user_data_script.sh"
          permissions = "0755"
          owner       = "root:root"
          encoding    = "b64"
          content     = filebase64("${path.module}/user_data_script.sh")
        },
      ]
    })}
  END
}
