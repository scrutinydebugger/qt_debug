Procedure to build QT in debug for testing the Scrutiny GUI

```bash
docker build . -t qtbuild
./fetch_sources.sh
./docker.sh ./build-qt.sh
./docker.sh ./build-pyside.sh

python3 -m venv venv
source venv/bin/activate
pip install ./pyside6-whl/*.whl
```