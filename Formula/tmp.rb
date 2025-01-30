class Tmp < Formula
  desc "RAII-wrappers for unique temporary files and directories for modern C++"
  homepage "https://github.com/bugdea1er/tmp"
  url "https://github.com/bugdea1er/tmp/archive/refs/tags/v2.tar.gz"
  sha256 "31ba807622a89fba5f526b105eab1c1ebbb5bf86b17a313d90b69f46fec1d827"
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
