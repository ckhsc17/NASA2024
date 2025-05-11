import difflib

def file_diff_percentage(file_a, file_b):
    with open(file_a, 'r') as fa, open(file_b, 'r') as fb:
        lines_a = fa.readlines()
        lines_b = fb.readlines()

    matcher = difflib.SequenceMatcher(None, lines_a, lines_b)
    match_size = sum(size for _, _, size in matcher.get_matching_blocks())
    total_size = max(len(lines_a), len(lines_b))

    percentage_diff = (total_size - match_size) / total_size * 100

    return percentage_diff

if __name__ == "__main__":
    file_a = "ex2-1.txt"  # Replace with your file paths
    file_b = "ex2-2.txt"

    percentage_diff = file_diff_percentage(file_a, file_b)
    print(f"Percentage Difference: {percentage_diff:.2f}%")

