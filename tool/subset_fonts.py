"""Subsets the bundled fonts down to the glyphs the site can actually show.

The full fonts in `assets/fonts/source/` (not bundled — pubspec only lists
the files in `assets/fonts/`) cover hundreds of scripts the site never
renders. This keeps Latin (Portuguese and English, with room to spare),
common punctuation, arrows and box drawing, plus every non-ASCII character
found in `lib/` and `packages/a11y_kit/lib/`, and writes the result to
`assets/fonts/`. Inter's optical-size axis is pinned to its default, since
the app never sets `opsz`.

Run again after adding text with characters outside those ranges:

    pip install fonttools
    python3 tool/subset_fonts.py
"""

import glob
import os

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCE_DIR = os.path.join(ROOT, 'assets', 'fonts', 'source')
OUT_DIR = os.path.join(ROOT, 'assets', 'fonts')

BASE_RANGES = [
    (0x0020, 0x007E),  # Basic Latin
    (0x00A0, 0x00FF),  # Latin-1 Supplement
    (0x0100, 0x017F),  # Latin Extended-A
    (0x2000, 0x206F),  # General Punctuation
    (0x20AC, 0x20AC),  # €
    (0x2122, 0x2122),  # ™
    (0x2190, 0x21FF),  # Arrows
    (0x2212, 0x2212),  # −
    (0x2500, 0x257F),  # Box Drawing
]

# Axes the app never varies, pinned to their default value.
PINNED_AXES = {'Inter.ttf': {'opsz': None}}


def used_codepoints():
    codepoints = set()
    for start, end in BASE_RANGES:
        codepoints.update(range(start, end + 1))
    patterns = ['lib/**/*.dart', 'lib/**/*.arb', 'packages/a11y_kit/lib/**/*.dart']
    for pattern in patterns:
        for path in glob.glob(os.path.join(ROOT, pattern), recursive=True):
            with open(path, encoding='utf-8') as f:
                codepoints.update(ord(c) for c in f.read() if ord(c) > 0x7E)
    return codepoints


def main():
    codepoints = used_codepoints()
    options = subset.Options()
    options.layout_features = ['*']  # Keep kerning, ligatures, tnum, …
    options.name_IDs = ['*']
    options.notdef_outline = True
    options.drop_tables += ['meta']

    for path in sorted(glob.glob(os.path.join(SOURCE_DIR, '*.ttf'))):
        name = os.path.basename(path)
        font = TTFont(path)
        subsetter = subset.Subsetter(options)
        subsetter.populate(unicodes=codepoints)
        subsetter.subset(font)
        if name in PINNED_AXES:
            axes = {
                axis.axisTag: axis.defaultValue
                for axis in font['fvar'].axes
                if axis.axisTag in PINNED_AXES[name]
            }
            font = instancer.instantiateVariableFont(font, axes)
        out = os.path.join(OUT_DIR, name)
        font.save(out)
        print(f'{name:28} {os.path.getsize(path) // 1024:5}K -> '
              f'{os.path.getsize(out) // 1024:4}K')


if __name__ == '__main__':
    main()
