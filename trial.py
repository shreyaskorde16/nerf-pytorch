import torch
import json
print(torch.__version__)  # Should output 1.11.0 or 2.3.0
print(torch.cuda.is_available())  # Should output True
print(torch.version.cuda)  # 11.3


split = ["train", "val", "test"]
#train_file = 'data/nerf_synthetic/cylinder/transforms_'

for s in split:
    train_file = f"data/nerf_synthetic/cylinder/transforms_{s}.json"
    # Load the JSON file
    with open(train_file, 'r') as f:
        data = json.load(f)

    # Fix file paths for all frames
    for frame in data['frames']:
        file_path = frame['file_path']
        # Replace backslashes with forward slashes
        file_path = file_path.replace('\\', '/')
        # Remove duplicate slashes
        file_path = file_path.replace('//', '/')
        # Update the frame's file_path
        frame['file_path'] = file_path
        if frame['file_path'].endswith('.png'):
            frame['file_path'] = frame['file_path'][:-4]
        print(frame['file_path'])
        #print(frame['file_path'][:-4])

    # Save the corrected JSON file
    with open(train_file, 'w') as f:
        json.dump(data, f, indent=4)

print(f"File paths in {train_file} have been standardized to use forward slashes.")