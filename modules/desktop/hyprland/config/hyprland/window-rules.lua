hl.window_rule({
    match = { title = "<floating>" },
    float = true,
    size  = { "monitor_w*0.8", "monitor_h*0.8" },
})

hl.window_rule({
    match = { class = "^(dev.noctalia.Noctalia)$" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

hl.window_rule({
    match = { class = "^(org.pipewire.Helvum)$" },
    float = true,
    size  = { "monitor_w*0.8", "monitor_h*0.8" },
})

-- Krita
hl.window_rule({
    match  = { title = "^(Saving As — Krita)$" },
    center = true,
    size   = { "monitor_w*0.7", "monitor_h*0.7" },
})

-- Ardour
hl.window_rule({
    match  = { class = "^(Ardour-[\\d+.]+)$", title = "^(Session Setup)$" },
    center = true,
})

hl.window_rule({
    match  = { class = "^(Ardour(-[\\d+.]+)?)$", title = "^.*(Helm|Calf|ACE|Select|SF2).*$" },
    center = true,
})

hl.window_rule({
    match = { class = "^(Ardour-[\\d+.]+)$", title = "^(Select|SF2).*$" },
    size  = { "monitor_w*0.5", "monitor_h*0.5" },
})
