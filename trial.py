import torch
print(torch.__version__)  # Should output 1.11.0 or 2.3.0
print(torch.cuda.is_available())  # Should output True
print(torch.version.cuda)  # 11.3