from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps
from conan.tools import CppInfo
from conan.tools.layout import basic_layout
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
        self.requires("zlib/1.2.13")
        self.requires("fmt/9.1.0")
        self.requires("protobuf/3.21.9")
        self.requires("nlohmann_json/3.11.2")   # header only

    def generate(self):
        tc = CMakeToolchain(self)
        tc.presets_prefix = self.options.platform
        tc.generate()
        dep = CMakeDeps(self)
        dep.generate()

        # print("------------deps info------------")
        # aggregated_cpp_info = CppInfo(self)
        # deps = self.dependencies.host.topological_sort
        # deps = [dep for dep in reversed(deps.values())]
        # for dep in deps:
        #     print(dep)
        #     dep_cppinfo = dep.cpp_info.aggregated_components()
        #     aggregated_cpp_info.merge(dep_cppinfo)
        #     for cname, c in dep_cppinfo.components.items():
        #         print(f"name: {cname}")
        # print(f"includedirs:")
        # [print(f"\t{d}") for d in aggregated_cpp_info.includedirs]
        # print(f"libdirs:")
        # [print(f"\t{d}") for d in aggregated_cpp_info.libdirs]
        # print(f"bindirs:")
        # [print(f"\t{d}") for d in aggregated_cpp_info.bindirs]
        # print(f"libs: {aggregated_cpp_info.libs}")
        # print(f"system_libs: {aggregated_cpp_info.system_libs}")

    def build_requirements(self):
        self.tool_requires("cmake/3.24.4")

    def layout(self):
        self.folders.generators = "conan"
        # basic_layout(self)
