class Tmp < Formula
  desc "RAII-wrappers for unique temporary files and directories for modern C++"
  homepage "https://github.com/bugdea1er/tmp"
  url "https://github.com/bugdea1er/tmp/archive/refs/tags/v0.7.tar.gz"
  sha256 "6d98e71d4ca08fee1f799b906579f83e67e2c80d1baf73c00024392d070eff51"
  license "MIT"
  head "https://github.com/bugdea1er/tmp.git", branch: "main"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DTMP_TEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <tmp/file>
      int main() {
        std::cout << tmp::file().release().native();
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-ltmp"
    assert_predicate Pathname.new(shell_output("./test")), :exist?
  end
end
