from fastapi import FastAPI
from pydantic import BaseModel
from pydantic_settings import BaseSettings
import httpx
from logging import getLogger, StreamHandler


class ContainerSSHpublicKeyRequest(BaseModel):
    connectionId: str
    publicKey: str
    remoteAddress: str
    username: str


class ContainerSSHpublicKeyResponse(BaseModel):
    connectionId: str
    remoteAddress: str
    success: bool
    username: str


class Settings(BaseSettings):
    stns_url: str = "http://stns:1104"


logger = getLogger(__name__)
logger.addHandler(StreamHandler())
logger.setLevel("INFO")
settings = Settings()
app = FastAPI()


@app.post("/pubkey", response_model=ContainerSSHpublicKeyResponse)
async def handle_pubkey(request: ContainerSSHpublicKeyRequest):
    key_matched = False
    async with httpx.AsyncClient() as client:
        try:
            query = f"{settings.stns_url}/v1/users?name={request.username}"
            logger.info(f"Querying STNS server: {query}")
            response = await client.get(query)
            if response.status_code == 200:
                keys = response.json()[0]["keys"]
                key_matched = request.publicKey in keys
            else:
                key_matched = False
                logger.info(
                    f"STNS server returned status code {response.status_code}: {response.text}"
                )
        except Exception as e:
            logger.error(f"Error querying STNS: {e}")

    return ContainerSSHpublicKeyResponse(
        connectionId=request.connectionId,
        remoteAddress=request.remoteAddress,
        success=key_matched,
        username=request.username,
    )


class HealthCheckResponse(BaseModel):
    status: str


@app.get("/", response_model=HealthCheckResponse)
async def health_check():
    return HealthCheckResponse(status="ok")
