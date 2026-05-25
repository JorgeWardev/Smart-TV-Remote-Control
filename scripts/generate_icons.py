"""Generate app icon and splash image for Smart TV Remote Control."""
from PIL import Image, ImageDraw, ImageFilter
from pathlib import Path

NAVY = (11, 26, 62, 255)        # #0B1A3E
CYAN = (0, 212, 255, 255)        # #00D4FF
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

OUT_DIR = Path(__file__).resolve().parent.parent / "assets" / "icons"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def rounded_rect(draw, xy, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def draw_remote(img, scale, body_color, accent_color, glow_color, with_glow=True):
    """Draw a stylized TV remote silhouette centered on img."""
    W, H = img.size
    cx, cy = W // 2, H // 2

    # Remote dimensions (scaled)
    rw = int(W * 0.36)
    rh = int(H * 0.72)
    radius = int(rw * 0.32)

    # --- Glow halo behind remote ---
    if with_glow:
        glow_layer = Image.new("RGBA", (W, H), TRANSPARENT)
        gdraw = ImageDraw.Draw(glow_layer)
        # Outer soft glow
        for i, alpha in enumerate([18, 28, 40]):
            pad = (3 - i) * int(W * 0.025)
            gdraw.rounded_rectangle(
                [cx - rw // 2 - pad, cy - rh // 2 - pad,
                 cx + rw // 2 + pad, cy + rh // 2 + pad],
                radius=radius + pad,
                fill=(glow_color[0], glow_color[1], glow_color[2], alpha),
            )
        glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=int(W * 0.04)))
        img.alpha_composite(glow_layer)

    draw = ImageDraw.Draw(img)

    # --- Remote body ---
    body_box = [cx - rw // 2, cy - rh // 2, cx + rw // 2, cy + rh // 2]
    rounded_rect(draw, body_box, radius=radius, fill=body_color)

    # Subtle inner highlight stripe at top (only when body is dark)
    if body_color != WHITE:
        hl = Image.new("RGBA", (W, H), TRANSPARENT)
        hd = ImageDraw.Draw(hl)
        hd.rounded_rectangle(
            [cx - rw // 2 + int(rw * 0.08), cy - rh // 2 + int(rh * 0.05),
             cx + rw // 2 - int(rw * 0.08), cy - rh // 2 + int(rh * 0.18)],
            radius=int(rw * 0.18),
            fill=(255, 255, 255, 14),
        )
        img.alpha_composite(hl)

    # --- Power button (glowing cyan circle near top) ---
    pb_r = int(rw * 0.22)
    pb_cy = cy - int(rh * 0.28)

    # Power button glow
    if with_glow:
        pglow = Image.new("RGBA", (W, H), TRANSPARENT)
        pgd = ImageDraw.Draw(pglow)
        for i, alpha in enumerate([40, 70, 110]):
            r = pb_r + (3 - i) * int(W * 0.018)
            pgd.ellipse([cx - r, pb_cy - r, cx + r, pb_cy + r],
                        fill=(accent_color[0], accent_color[1], accent_color[2], alpha))
        pglow = pglow.filter(ImageFilter.GaussianBlur(radius=int(W * 0.022)))
        img.alpha_composite(pglow)

    # Power button face
    draw = ImageDraw.Draw(img)
    draw.ellipse([cx - pb_r, pb_cy - pb_r, cx + pb_r, pb_cy + pb_r], fill=accent_color)

    # Power icon (arc + line) cut from button face in body color
    inner_r = int(pb_r * 0.55)
    arc_box = [cx - inner_r, pb_cy - inner_r, cx + inner_r, pb_cy + inner_r]
    line_w = max(3, int(pb_r * 0.18))
    # Arc (open at top)
    draw.arc(arc_box, start=300, end=240, fill=body_color, width=line_w)
    # Vertical bar
    draw.line([(cx, pb_cy - int(inner_r * 1.05)), (cx, pb_cy + int(inner_r * 0.1))],
              fill=body_color, width=line_w)

    # --- D-pad / button cluster (simple rounded square + center dot) ---
    dp_size = int(rw * 0.5)
    dp_cy = cy + int(rh * 0.02)
    dp_box = [cx - dp_size // 2, dp_cy - dp_size // 2,
              cx + dp_size // 2, dp_cy + dp_size // 2]
    dp_color = (accent_color[0], accent_color[1], accent_color[2], 90)
    rounded_rect(draw, dp_box, radius=int(dp_size * 0.22), fill=dp_color)
    # Center button
    cb_r = int(dp_size * 0.18)
    draw.ellipse([cx - cb_r, dp_cy - cb_r, cx + cb_r, dp_cy + cb_r], fill=accent_color)

    # --- Bottom pill buttons (2 rows of 2) ---
    btn_w = int(rw * 0.28)
    btn_h = int(rh * 0.05)
    gap_x = int(rw * 0.1)
    gap_y = int(rh * 0.04)
    start_y = cy + int(rh * 0.22)
    btn_color = (accent_color[0], accent_color[1], accent_color[2], 75)
    for row in range(2):
        for col in range(2):
            bx = cx - btn_w - gap_x // 2 + col * (btn_w + gap_x)
            by = start_y + row * (btn_h + gap_y)
            rounded_rect(draw, [bx, by, bx + btn_w, by + btn_h],
                         radius=btn_h // 2, fill=btn_color)


def make_app_icon():
    """1024x1024 app icon with navy background."""
    size = 1024
    img = Image.new("RGBA", (size, size), NAVY)

    # Subtle radial-ish vignette via concentric soft rects
    vignette = Image.new("RGBA", (size, size), TRANSPARENT)
    vd = ImageDraw.Draw(vignette)
    for i in range(8):
        pad = i * 60
        alpha = 6
        vd.ellipse([pad, pad, size - pad, size - pad],
                   fill=(0, 212, 255, alpha))
    vignette = vignette.filter(ImageFilter.GaussianBlur(radius=80))
    img.alpha_composite(vignette)

    draw_remote(img, scale=1.0, body_color=(20, 38, 80, 255),
                accent_color=CYAN, glow_color=CYAN, with_glow=True)

    out = OUT_DIR / "app_icon.png"
    img.save(out, "PNG")
    print(f"Wrote {out} ({size}x{size})")


def make_splash():
    """600x600 splash with transparent background, white/cyan remote."""
    size = 600
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw_remote(img, scale=1.0, body_color=WHITE,
                accent_color=CYAN, glow_color=CYAN, with_glow=True)
    out = OUT_DIR / "splash.png"
    img.save(out, "PNG")
    print(f"Wrote {out} ({size}x{size})")


if __name__ == "__main__":
    make_app_icon()
    make_splash()
