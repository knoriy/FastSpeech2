import os
import argparse
import pandas as pd
import pathlib
import numpy as np

from hparm import HParam

def main(config:str):
    out_dir = config.path.preprocessed_path
    os.makedirs(os.path.join(out_dir, "emotion"), exist_ok=True)


    df = pd.read_csv(os.path.join(config.path.corpus_path, "metadata.csv"), sep="|")
    df['emotion_id'], _ = pd.factorize(df['emotion'])

    speaker = "EMNS"

    for row in df.iloc():
        basename = pathlib.Path(row["audio_recording"]).stem
        emotion = row["emotion_id"]
        emotion_filename = "{}-emotion-{}.npy".format(speaker, basename)

        np.save(os.path.join(out_dir, "emotion", emotion_filename), emotion)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "preprocess_config",
        type=str,
        help="path to preprocess.yaml",
    )
    args = parser.parse_args()

    cfg = HParam(args.preprocess_config)
    main(cfg)