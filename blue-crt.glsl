void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Sample the text texture (assuming white text on black background)
    float textAlpha = texture(iChannel0, uv).r;

    // **Blue Phosphor Color** (Cool electric blue)
    vec3 bluePhosphor = vec3(0.4, 0.8, 1.2);  // Slightly cyan-tinted for realism

    // **Sharper Inner Glow Effect** (higher influence near text)
    float innerGlow = textAlpha * 2.8;  
    innerGlow += texture(iChannel0, uv + vec2(0.001, 0.0)).r * 0.6;
    innerGlow += texture(iChannel0, uv - vec2(0.001, 0.0)).r * 0.6;
    innerGlow += texture(iChannel0, uv + vec2(0.0, 0.001)).r * 0.6;
    innerGlow += texture(iChannel0, uv - vec2(0.0, 0.001)).r * 0.6;

    // **Softer Outer Glow Effect** (minimal spread to avoid blurring)
    float outerGlow = textAlpha * 0.4;
    outerGlow += texture(iChannel0, uv + vec2(0.0025, 0.0)).r * 0.3;
    outerGlow += texture(iChannel0, uv - vec2(0.0025, 0.0)).r * 0.3;
    outerGlow += texture(iChannel0, uv + vec2(0.0, 0.0025)).r * 0.3;
    outerGlow += texture(iChannel0, uv - vec2(0.0, 0.0025)).r * 0.3;

    // **Sharpened Glow Combination**
    float glow = mix(innerGlow, outerGlow, 0.5);

    // **Subtle Blue Background Glow**
    float bgGlowIntensity = 0.2;  // Adjust for stronger/weaker effect
    float bgGlow = bgGlowIntensity * smoothstep(1.2, 0.2, length(uv - 0.5));
    vec3 backgroundColor = bluePhosphor * bgGlow * 0.4;  // Soft blue glow

    // **Subtle Scanline Effect (Minimized)**
    float scanlineStrength = 0.98 + 0.02 * sin(uv.y * iResolution.y * 3.1415 * 1.5);

    // **Flicker Effect (Subtle)**
    float flicker = 0.99 + 0.01 * sin(iTime * 100.0);

    // **Final Color Composition**
    vec3 color = backgroundColor + (bluePhosphor * glow * scanlineStrength * flicker);

    // **Ensure sharp, readable text** by making alpha stronger
    fragColor = vec4(color, clamp(textAlpha + glow * 0.5, 0.0, 1.0));
}
