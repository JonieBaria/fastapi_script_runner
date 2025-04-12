from fastapi import Request, APIRouter
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.templating import Jinja2Templates
import subprocess
import os
import sys

app = APIRouter()
templates = Jinja2Templates(directory="templates")

@app.get("/", response_class=HTMLResponse)
def home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "output": "", "error": "", "script_name": ""})

@app.post("/run-script/{script_name}", response_class=HTMLResponse)
def run_script(request: Request, script_name: str):
    script_file = ""

    if script_name == "scrape":
        script_file = "my_script.py "
    elif script_name == "standalone":
        script_file = "my_script.py"
    else:
        return templates.TemplateResponse("index.html", {
            "request": request,
            "output": "",
            "error": "Unknown script.",
            "script_name": script_name
        })

    try:
        result = subprocess.run(
            ["python", script_file],
            capture_output=True,
            text=True
        )
        return templates.TemplateResponse("index.html", {
            "request": request,
            "output": result.stdout.strip(),
            "error": result.stderr.strip(),
            "script_name": script_name
        })
    except Exception as e:
        return templates.TemplateResponse("index.html", {
            "request": request,
            "output": "",
            "error": str(e),
            "script_name": script_name
        })

@app.post("/scrape-quotes")
def scrape_quotes(request: Request):
    try:
        script_path = os.path.join(os.path.dirname(__file__), "scrape_quotes.py")

        result = subprocess.run(
            [sys.executable, script_path],
            capture_output=True,
            text=True,
            timeout=30
        )

        if result.returncode != 0:
            return JSONResponse(status_code=500, content={
                "success": False,
                "error": result.stderr.strip(),
                "output": result.stdout.strip(),
                "exit_code": result.returncode
            })

        return JSONResponse(content={
            "success": True,
            "output": result.stdout.strip(),
            "error": "",
            "exit_code": result.returncode
        })

    except Exception as e:
        return JSONResponse(status_code=500, content={
            "success": False,
            "output": "",
            "error": str(e)
        })


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)