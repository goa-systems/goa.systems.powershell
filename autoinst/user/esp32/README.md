# ESP-Idf installation

1. Set environment variables and create directories<br>
    ```$env:IDF_PATH```<br>
    ```$env:IDF_TOOLS_PATH```
2. Install Idf:<br>
    ```git clone --recursive https://github.com/espressif/esp-idf.git $env:IDF_PATH```
3. Install<br>
    ```."$env:IDF_PATH\install.ps1"```
4. Upgrade pip<br>
    ```$env:IDF_TOOLS_PATH\python_env\idf4.3_py3.8_env\Scripts\python.exe -m pip install --upgrade pip```
5. Export<br>
    ```."$env:IDF_PATH\export.ps1"```
