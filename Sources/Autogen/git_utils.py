from git import Repo, RemoteProgress
from tqdm import tqdm
from utils import this_dir

# https://stackoverflow.com/a/65576165
class ProgressHandler(RemoteProgress):
    def __init__(self, desc):
        super().__init__()
        self.pbar = tqdm()
        self.pbar.set_description_str(desc)

    def update(self, op_code, cur_count, max_count=None, message=''):
        self.pbar.total = max_count
        self.pbar.n = cur_count
        self.pbar.refresh()


def make_sure_remote_repo_is_downloaded(name: str, remote_url: str, branch: str = None) -> Repo:
    repo = Repo.init(f"{this_dir}/{name}", mkdir=True)
    try:
        remote = repo.remote(name)
    except:
        remote = repo.create_remote(
            name, remote_url)
    remote.pull(branch, progress=ProgressHandler(desc=f"Downloading {name} ({remote_url})"))
    return repo