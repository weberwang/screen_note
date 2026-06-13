---
version: alpha
name: Screen Note Shared Design System
description: A calm, lockscreen-first iOS productivity system focused on one obvious primary reminder, reliable urgency cues, low-friction follow-through, and a restrained touch of tactile warmth.
colors:
  primary: "#4D8B52"
  on-primary: "#FFFFFF"
  secondary: "#6E7B6F"
  tertiary: "#F08A32"
  surface: "#FBFAF7"
  on-surface: "#1F2328"
  surface-container: "#FFFFFF"
  surface-subtle: "#F3F5F0"
  outline: "#E4E8E0"
  success: "#4D8B52"
  warning: "#F08A32"
  danger: "#E96A5A"
  info: "#8A958C"
typography:
  display-lg:
    fontFamily: "SF Pro Display"
    fontSize: 48px
    fontWeight: "700"
    lineHeight: 56px
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: "SF Pro Display"
    fontSize: 34px
    fontWeight: "700"
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: "SF Pro Display"
    fontSize: 28px
    fontWeight: "700"
    lineHeight: 34px
    letterSpacing: -0.02em
  title-md:
    fontFamily: "SF Pro Display"
    fontSize: 20px
    fontWeight: "600"
    lineHeight: 26px
  body-md:
    fontFamily: "SF Pro Text"
    fontSize: 16px
    fontWeight: "400"
    lineHeight: 24px
  body-sm:
    fontFamily: "SF Pro Text"
    fontSize: 14px
    fontWeight: "400"
    lineHeight: 20px
  label-sm:
    fontFamily: "SF Pro Text"
    fontSize: 12px
    fontWeight: "600"
    lineHeight: 16px
rounded:
  sm: 8px
  md: 16px
  lg: 28px
  xl: 36px
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  xxl: 40px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.title-md}"
    rounded: "{rounded.full}"
    padding: "{spacing.md}"
  card-priority:
    backgroundColor: "{colors.surface-container}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.xl}"
    padding: "{spacing.xl}"
  task-row:
    backgroundColor: "{colors.surface-container}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  chip-status:
    backgroundColor: "{colors.surface-subtle}"
    textColor: "{colors.secondary}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.full}"
---

## Overview

This system should feel like a trustworthy iPhone utility rather than a complex task manager. The visual personality is quiet, airy, stable, and lightly tactile. The user should understand what matters now in the first 3 seconds, with one dominant reminder card, a clearly ordered urgency list, and one persistent quick-add action. The design must preserve a lockscreen-first mindset: show the most important thing first, reduce decision fatigue, and never bury the main task behind decorative UI.

## Colors

The palette is soft and natural, led by warm off-white surfaces, paper-ivory hero treatment, and a restrained green primary. Green represents stable action, safe completion, and calm confidence. Orange is reserved for “today” or rising urgency. Coral-red is reserved for overdue or risk states and should be used sparingly so urgency remains meaningful. Neutral grays support metadata, dividers, and low-priority system text. Contrast must remain strongest on the primary reminder title, section headers, and critical status text.

Light mode is the default workflow baseline. Do not introduce dark-first styling or high-saturation accents that reframe the product as entertainment or heavy productivity software.

## Typography

Typography carries most of the hierarchy. The system should rely on bold display and headline styles for the primary reminder, while task rows and metadata stay compact and scannable. The main reminder title may become large and two-line when needed, but supporting copy must remain quieter and shorter. Section labels should feel explicit, not decorative. Body text should stay highly readable, with enough line height to avoid a cramped utility feel.

## Layout

The frozen base design viewport for this cycle is `390 x 844 px`. Shared layouts must not collapse below that size. The shell uses a top-to-bottom flow with large outer margins, one dominant hero region, one urgency section, and one persistent bottom navigation zone. Whitespace is not optional polish here; it is the primary tool for clarifying task priority.

Content density posture:

- Phone surfaces expose one primary reminder immediately.
- Secondary queues appear below the fold or in lighter grouped rows.
- Tertiary settings, explanation text, and long-tail metadata move into secondary screens instead of crowding the home surface.

Do not solve density problems by shrinking typography or compressing structural breathing room.

## Elevation & Depth

Depth should be soft and restrained. Priority cards and task rows may lift subtly from the background with gentle shadows and soft edge definition, but the interface should not feel glassy, glossy, or dashboard-like. Depth exists only to support hierarchy and tap confidence. Avoid stacked elevation patterns and avoid turning every section into a separate raised island.

## Shapes

The shape language is rounded, soft, and iOS-native. Large task surfaces use generous radii to feel approachable and stable. Chips, pills, and the primary quick-add action should use fully rounded ends. Checkbox and utility controls may be slightly firmer, but still belong to the same rounded family. Sharp corners, rigid enterprise geometry, and novelty cutouts are out of scope. The hero card may carry a faint warm paper texture, but that tactility should stay subtle and never become heavy skeuomorphism.

## Components

Shared public component families:

- `Priority Reminder Card`: one dominant hero card for the most important active task, with title, due metadata, status cue, and restrained paper-soft tactility.
- `Task Row`: compact, tappable row for urgency queue and normal queue items.
- `Status Chip`: lightweight pill for today, overdue, tomorrow, and privacy-safe states.
- `Bottom Navigation`: exactly three destinations in the shared shell: Home, History, Settings.
- `Quick Add Action`: a persistent, highly discoverable global action that never competes with bottom navigation labels.
- `Completion Control`: a simple check affordance that reads as immediate progress, never as a destructive action.

Shared component rules:

- Global quick add should remain visually dominant but not louder than the main reminder title.
- Task rows should read as one grouped list family, not isolated mini-cards with unrelated styling.
- Overdue styling may intensify text or accent color, but should not change the whole visual language.
- Privacy-safe states must replace exposed content with secure placeholders rather than partial leaks.
- The hero card may feel warmer than the list area, but the list must stay cleaner and more utility-like.

## Task Priorities

The highest-priority job is to help the user notice and act on the single most important reminder quickly. On the home surface, the order of understanding must be:

1. what matters right now
2. whether it is overdue, due today, or upcoming
3. what to do next
4. how to quickly add a new reminder

The primary CTA is not an abstract management action. It is either the main task itself, its immediate handling affordance, or the global quick add. The first-screen experience must never look like a generic project dashboard or a feature browser.

## Interaction & Feedback

Interactions should feel direct, lightweight, and consistent. Taps must respond quickly with subtle scale, tint, or shadow feedback. Completion, delete, restore, and snooze-like actions should feel controlled and reversible where appropriate. Error and permission-denied states must explain the downgrade clearly without implying that the task itself is gone.

Motion posture should be restrained:

- quick sheet reveals
- soft list-state transitions
- stable bottom-nav transitions
- no playful or theatrical motion

Loading, success, warning, disabled, and recovery states must preserve the same calm system tone.

## Responsive Strategy

The primary target is iPhone at `390 x 844 px`. Tablet and larger surfaces may widen spacing, allow more side breathing room, or reveal slightly more secondary context, but must preserve the same hierarchy: one dominant task, one secondary queue, one shared shell. Responsive behavior may reflow spacing and card width, but must not invent a second visual language or turn the product into a dense planning dashboard.

Locked visual relationships:

- dominant first reminder
- compact urgency queue below it
- three-destination shared shell
- persistent quick-add availability

Adaptable regions:

- number of visible secondary rows
- spacing between grouped sections
- metadata wrapping length

## States & Edge Cases

The system must intentionally handle:

- first-use empty state
- no urgent tasks state
- overdue state
- loading state
- widget refresh failed state
- notification permission denied state
- long title and short title states
- privacy-safe lockscreen state
- recent delete and recent complete history states

An empty state should reassure the user and immediately point to quick add. A failed widget or notification state should describe capability downgrade without implying data loss. Long titles may wrap inside the hero card, but the due status and primary action must remain visible.

## Content & Tone

The writing tone should be calm, explicit, and supportive. It should sound like a dependable personal assistant, not a gamified coach and not a corporate operations tool. CTA copy should be short and direct. Recovery copy should reduce panic, especially around delete, permission denial, and refresh failure. Labels should prefer everyday language over system jargon. Even with the warmer visual treatment, copy should remain concise and utility-first rather than expressive or editorial.

## Do's and Don'ts

- Do preserve one obvious primary reminder on the home surface.
- Do keep Home, History, and Settings as the only shared shell destinations.
- Do use whitespace, typography, and grouping before reaching for extra cards or borders.
- Do keep urgency accents sparse so overdue states remain meaningful.
- Do preserve the same style direction, theme system, shell posture, and component families across all restored screens.
- Do design privacy-safe, empty, loading, error, and downgrade states intentionally.
- Do keep hero-card tactility subtle and local.
- Don't turn the app into a dense agenda planner, kanban board, or enterprise dashboard.
- Don't compress spacing just to fit more rows into the first screen.
- Don't let the quick add action overshadow the primary task title.
- Don't introduce purple gradients, playful illustration systems, or decorative visual noise.
- Don't let tactile warmth drift into full sticky-note metaphor, handwritten typography, or heavy paper props.
- Don't hide critical task status behind menus, tabs, or secondary surfaces.
