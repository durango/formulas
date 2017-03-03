class RiakTs < Formula
  desc "NoSQL time series database optimized for IoT and Time Series data."
  homepage "http://basho.com/products/riak-ts/"
  url "http://s3.amazonaws.com/downloads.basho.com/riak_ts/1.5/1.5.2/osx/10.8/riak-ts-1.5.2-OSX-x86_64.tar.gz"
  version "1.5.2"
  sha256 "d7e58fba208388ec2db510213fbdd495dbaaacbcdc1d3bba9f6e75833719568b"

  bottle :unneeded

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    logdir = var + "log/riak-ts"
    datadir = var + "lib/riak-ts"
    libexec.install Dir["*"]
    logdir.mkpath
    (datadir + "ring").mkpath
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
      s.change_make_var! "RUNNER_LOG_DIR", logdir
    end
    inreplace "#{libexec}/etc/riak.conf" do |c|
      c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
      c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
    end
    %w[riak riak-admin riak-debug riak-shell search-cmd].each do |script|
      bin.write_exec_script libexec/"bin/#{script}"
    end
  end

  test do
  end
end

