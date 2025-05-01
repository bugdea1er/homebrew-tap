class Tmp < Formula
  desc "RAII-wrappers for unique temporary files and directories for modern C++"
  homepage "https://github.com/bugdea1er/tmp"
  url "https://github.com/bugdea1er/tmp/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "de367d91a4552bd7ea02d077737b0a58e91aa50ae0084e40402ad9534d2ba6a9"
  license "MIT"
  head "https://github.com/bugdea1er/tmp.git", branch: "main"

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
      #include <tmp/directory>
      int main() {
        return std::filesystem::exists(tmp::directory()) ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-ltmp"
    shell_output("./test")
  end
end
