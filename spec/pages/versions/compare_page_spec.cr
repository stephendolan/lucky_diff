require "../../spec_helper"

describe "Versions::ComparePage file counting" do
  it "correctly counts files with macOS diff format" do
    # Test the actual regex pattern used
    diff_output = <<-DIFF
diff --color=never -I s*settings.secret_key_base.* -b -Nr -U 20 .crystal-version .crystal-version
--- .crystal-version
+++ .crystal-version
@@ -1 +1 @@
-1.12.1
+1.16.3
diff --color=never -I s*settings.secret_key_base.* -b -Nr -U 20 shard.yml shard.yml
--- shard.yml
+++ shard.yml
@@ -1,36 +1,36 @@
 ---
 name: my_app
diff --color=never -I s*settings.secret_key_base.* -b -Nr -U 20 script/setup script/setup
--- script/setup
+++ script/setup
@@ -1,45 +0,0 @@
-#!/usr/bin/env bash
DIFF

    # Test the regex directly
    file_count = diff_output.scan(/^diff --color=never/m).size
    file_count.should eq(3)
  end

  it "counts single file" do
    diff_output = <<-DIFF
diff --color=never -I s*settings.secret_key_base.* -b -Nr -U 20 .crystal-version .crystal-version
--- .crystal-version
+++ .crystal-version
DIFF

    file_count = diff_output.scan(/^diff --color=never/m).size
    file_count.should eq(1)
  end

  it "counts many files" do
    # Generate diff with 13 files like the real example
    diff_parts = [] of String
    13.times do |i|
      diff_parts << "diff --color=never -I s*settings.secret_key_base.* -b -Nr -U 20 file#{i}.cr file#{i}.cr"
    end
    
    diff_output = diff_parts.join("\n")
    file_count = diff_output.scan(/^diff --color=never/m).size
    file_count.should eq(13)
  end

  it "handles empty diff" do
    diff_output = ""
    file_count = diff_output.scan(/^diff --color=never/m).size
    file_count.should eq(0)
  end
end