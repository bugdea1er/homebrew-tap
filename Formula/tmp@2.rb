class TmpAT2 < Formula
  desc "RAII-wrappers for unique temporary files and directories for modern C++"
  homepage "https://github.com/bugdea1er/tmp"
  url "https://github.com/bugdea1er/tmp/archive/refs/tags/v2.1.tar.gz"
  sha256 "0ebd2e787e8c23681da1ea0c4e31276827c323b28902f9083675c1909f2c375a"
  license "MIT"
  head "https://github.com/bugdea1er/tmp.git", branch: "main"

  keg_only :versioned_formula

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libtmp.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <filesystem>
      #include <tmp/file>
      int main() {
        return std::filesystem::exists(tmp::file()) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-ltmp"
    shell_output("./test")
  end
end
