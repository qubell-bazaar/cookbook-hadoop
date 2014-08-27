if node.aws.accessId.length > 0 && node.aws.secretKey.length > 0
  cmd = "hadoop distcp  -Dfs.s3n.awsAccessKeyId=#{node.aws.accessId} -Dfs.s3n.awsSecretAccessKey=#{node.aws.secretKey}" +
      " -overwrite -delete #{node.dataset.src_path} #{node.dataset.dst_path}"
else
  cmd = "hadoop distcp -overwrite -delete #{node.dataset.src_path} #{node.dataset.dst_path}"
end

execute "Run hadoop destcp" do
  command cmd
  user "hdfs"
end
