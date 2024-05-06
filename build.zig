const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86,
            .os_tag = .windows,
        },
    });
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "MBAACC-Extended-Training-Mode",
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    exe.linkLibCpp();
    exe.root_module.addCSourceFiles(.{
        .root = b.path("MBAACC-Extended-Training-Mode"),
        .files = cxxsource,
        .flags = cxxflags,
    });

    const curl = b.option(bool, "curl", "use curl for autoupdating and checking version information (default: true)") orelse true;
    if (curl == true) exe.root_module.addCMacro("USE_CURL", "");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

const cxxsource = &[_][]const u8{
    "MBAACC-Extended-Training-Mode.cpp",
};
const cxxflags = &[_][]const u8{""};
