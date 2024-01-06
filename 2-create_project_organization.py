import os
import warnings
import urllib.request

def create_project_organization():
    current_wd = os.getcwd()

    # 创建文件夹结构
    folders = ["1-code", "2-data", "3-data_analysis", "4-manuscript", 
               "4-manuscript/Figures", "4-manuscript/Supplementary_data", 
               "4-manuscript/Supplementary_figures", "5-summary"]
    for folder in folders:
        folder_path = os.path.join(current_wd, folder)
        os.makedirs(folder_path, exist_ok=True)

    # 创建和写入文件
    tools_file = os.path.join(current_wd, "1-code", "100-tools.py")
    demo_code_file = os.path.join(current_wd, "1-code", "101-demo_code.py")
    summary_file = os.path.join(current_wd, "5-summary", "demo_summary.pptx")

    if not os.path.exists(tools_file):
        with open(tools_file, 'w') as file:
            file.write("library(tidyverse)\nlibrary(ggplot2)")
    else:
        warnings.warn("'1-code/100-tools.py' already exists. Not overwriting.\n")

    with open(demo_code_file, 'w') as file:
        file.write("library(r4projects)\nsetwd(get_project_wd())\nrm(list = ls())\nsource('1-code/100-tools.py')")

    # 下载文件
    url = "https://jaspershen.github.io/file/demo_summary.pptx"
    urllib.request.urlretrieve(url, summary_file)

# 调用函数
create_project_organization()
