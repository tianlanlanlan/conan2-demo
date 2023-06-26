from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps
import os


class Conan2DemoRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    options = {
        "platform": ["linux", "riscv", "arm"]
    }
    default_options = {
        "platform": "linux"
    }

    def requirements(self):
        self.requires("zlib/1.2.11")
        self.requires("fmt/9.1.0")

    def generate(self):
        tc = CMakeToolchain(self)
        tc.presets_prefix = self.options.platform
        tc.generate()
        dep = CMakeDeps(self)
        dep.generate()

    def build_requirements(self):
        self.tool_requires("cmake/3.24.4")

    def layout(self):
        self.folders.source = "."
        self.folders.generators = "generators"
