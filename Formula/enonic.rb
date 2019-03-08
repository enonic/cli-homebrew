class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://github.com/enonic/enonic-cli.git",
      :tag      => "0.5.3",
      :revision => "cf4753abe2ee6510305c78b37af7b0613496c513"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    revision = Utils.popen_read("git rev-parse HEAD").strip
    today = Date.today
    dir = buildpath/"src/github.com/enonic/enonic-cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.date=#{today}", "-o", bin/"enonic", "./internal/app/cli.go"
    end
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end
