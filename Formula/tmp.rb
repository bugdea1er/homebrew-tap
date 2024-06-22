class Tmp < Formula
  desc "RAII-wrappers for unique temporary files and directories for modern C++"
  homepage "https://github.com/bugdea1er/tmp"
  url "https://api.github.com/repos/bugdea1er/tmp/tarball/v0.9"
  sha256 "589a991d8baa8567bfed3c5b7ea13931ad9b74d6c93fa5ff4eb9f827edfe9428"
  license "MIT"
  head "https://github.com/bugdea1er/tmp.git", branch: "main"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
