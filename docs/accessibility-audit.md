# Accessibility Audit Results

A structured record of the manual accessibility validation carried out for the iOSDevUK Accessibility Challenge 2026 submission. Code-side improvements are documented in the main [`README.md`](../README.md); this file captures the on-device verification.

**Device:** _e.g. iPhone 16 running iOS 26.4.2
**Tester:** Trevor Doodes
**Date completed:** _YYYY-MM-DD_

---

## Per-screen audit

For each screen, walk through with each assistive technology and tick when verified or note any issue with a brief description and the corresponding code change (if any).

### Programme tab

| Check | VoiceOver | Voice Control | Increase Contrast | Differentiate Without Color | AX5 Dynamic Type | Reduce Motion |
|---|---|---|---|---|---|---|
| Day picker reads correctly | ✅ | ✅| ✅ | n/a | ✅ | n/a |
| Talk cards read in one focus stop | ✅| ✅| ✅ | ✅ | ✅ | n/a |
| Time reads naturally ("from 09:30 to 10:15") | ✅ | n/a | ✅ | n/a | ✅ | n/a |
| Speakers and location follow the title | ✅ | n/a | n/a | n/a | n/a | n/a |
| Favourite button focusable separately from card | ✅ | ✅ | ✅ | ✅ | ✅ | n/a |
| 88pt favourite hit area comfortable | n/a | n/a | n/a | n/a | ✅ | n/a |
| Custom announcement plays cleanly | ✅ | n/a | n/a | n/a | n/a | n/a |
| Differentiated haptic — add vs remove distinguishable | n/a | n/a | n/a | n/a | n/a | n/a |
| Break rows show session-type symbol | n/a | n/a | n/a | ✅| ✅ | n/a |
| Card border visible | n/a | n/a | ✅ | ✅ | n/a | n/a |
| Time column doesn't truncate | n/a | n/a | n/a | n/a | ✅ | n/a |
| Star bounce respects Reduce Motion | n/a | n/a | n/a | n/a | n/a | ✅ |

**Notes:** Manual pass found `.symbolEffect(.bounce, value:)` still played with system Reduce Motion on, despite Apple's guidance that symbol effects auto-suppress. `.symbolEffectsRemoved(_:)` did not help either — it only governs *indefinite* symbol effects, while `.bounce` triggered by a value-change is discrete. Fixed in `FavouriteButtonView.swift` by reading `@Environment(\.accessibilityReduceMotion)` and conditionally omitting the `.symbolEffect` modifier from the view tree entirely when Reduce Motion is on.

### Speakers tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Speaker rows read as one focus stop | ✅ | ✅ | ✅ | ✅|
| Voice Control activates by speaker name | n/a | ✅ | n/a | n/a |
| Search field announces result count | ✅ | n/a | n/a | n/a |
| Bio text adapts to Increase Contrast | n/a | n/a | ✅ | n/a |
| Speaker detail "Sessions" announces as heading | ✅ | n/a | n/a | n/a |
| Social links hint "Opens in browser" | ✅ | n/a | n/a | n/a |

**Notes:**

### Locations tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Location rows read as one focus stop |  ✅| ✅ | ✅ | ✅|
| Voice Control activates by location name | n/a | ✅ | n/a | n/a |
| Map labelled with venue name | ✅ | n/a | n/a | n/a |
| Map hint directs to text description | ✅ | n/a | n/a | n/a |
| Description text adapts to Increase Contrast | n/a | n/a | ✅| n/a |

**Notes:** During the manual pass the Map was reading its embedded `Marker` ("<venue name>, shows more info") instead of the outer `.accessibilityLabel`/`.accessibilityHint`. Fixed by adding `.accessibilityElement()` ahead of the label and hint in `LocationDetailView.swift` so the marker's accessibility subtree is collapsed and the custom hint ("Scroll down for a text description of this venue.") is what VoiceOver announces.

### My Schedule tab

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Empty state reads sensibly | ✅ | n/a | n/a | n/a |
| Day headings announced as headers | ✅ | n/a | n/a | n/a |
| Sessions read as on the Programme tab | ✅ | ✅ | ✅ | ✅ |
| No double-announce when scrolling pinned headers | ✅ | n/a | n/a | n/a |

**Notes:**

### Session detail

| Check | VoiceOver | Voice Control | Increase Contrast | AX5 Dynamic Type |
|---|---|---|---|---|
| Title announced as heading | ✅ | n/a | n/a | ✅ |
| Time and location read clearly | ✅ | n/a | ✅ | ✅ |
| Speakers focusable as composite rows | ✅| ✅ | ✅ | ✅ |
| Description reads as one block | ✅ | n/a | n/a | ✅ |
| Toolbar favourite button compact, not oversized | n/a | n/a | n/a | ✅ |
| Toolbar favourite announces selected state | ✅ | n/a | n/a | n/a |
| Toolbar favourite triggers same announcement | ✅ | n/a | n/a | n/a |

**Notes:** Manual VoiceOver pass found the time element only read "Time X to Y" with no venue context; the venue followed as a separate stop. Extended the time's `.accessibilityLabel` in `SessionDetailView.swift` to include the venue name ("Time X to Y, at <venue>") so the two pieces are announced together on first focus, while the venue `NavigationLink` remains a separate, tappable focus stop.

### Tab bar

| Check | VoiceOver | Voice Control |
|---|---|---|
| Each tab has an item label | ✅ | n/a |
| Voice Control accepts each natural alias | n/a | ✅ |

**Notes:**

---

## Accessibility Inspector audit

Run **Xcode → Open Developer Tool → Accessibility Inspector → Audit** on each screen with the iOS Simulator running. Capture warnings and resolutions below.

| Screen | Warnings found | Resolved? | Notes |
|---|---|---|---|
| Programme | _0_ | ✅ / ❌ | |
| Programme — talk card | | | |
| Programme — break row | | | |
| Speakers list | | | |
| Speaker detail | | | |
| Locations list | | | |
| Location detail | | | |
| Session detail | | | |
| My Schedule (empty) | | | |
| My Schedule (with favourites) | | | |

---

## Dynamic Type stress test (AX5)

| Screen | Layout intact at AX5? | Notes |
|---|---|---|
| Programme | ☐ | |
| Speakers | ☐ | |
| Locations | ☐ | |
| My Schedule | ☐ | |
| Session detail | ☐ | |
| Speaker detail | ☐ | |
| Location detail | ☐ | |

---

## Differentiated haptic verification (real device only)

| Action | Haptic perceived | Distinguishable from the other action? |
|---|---|---|
| Add to favourites (`.success`) | ✅ | ✅ |
| Remove from favourites (`.impact(weight: .light)`) | ✅ | ✅|

---

## Outcomes

_Summarise the overall result of the validation pass: anything that was working as designed, anything caught and fixed, anything intentionally accepted as a known limitation._

---

## Appendix — How to reproduce this audit

A short walkthrough so judges (or future contributors) can repeat each section of the audit on their own device or simulator. The simulator used during development was iPhone 17 / iOS 26.4.1; any iPhone running iOS 18+ should behave equivalently for the items checked below.

### Per-screen pass — assistive technologies

**VoiceOver.** Settings → Accessibility → VoiceOver. Also bind it to Accessibility Shortcut so a triple-click of the side button toggles it. Gestures: swipe right/left to move focus, double-tap to activate, two-finger swipe up to read the screen, two-finger rotation to switch the rotor. Walk each tab from top-left, ticking the column once each focus stop announces something close to the row's description.

**Voice Control.** Settings → Accessibility → Voice Control. Say "Show names" to overlay every actionable element's accessibility name; "Tap [name]" to activate. The favourite button has aliases ("Favourite", "Star", "Save") and tab bar items have multiple aliases each — see the test pass in `HomeView.swift` and `FavouriteButtonView.swift`.

**Increase Contrast.** Settings → Accessibility → Display & Text Size → Increase Contrast. Talk-card backgrounds change from 10 % tint to 25 % tint with a stroked border; `contrastAdaptiveSecondary()` lifts captions from `.secondary` to `.primary`.

**Differentiate Without Color.** Settings → Accessibility → Display & Text Size → Differentiate Without Color. Each `SessionType` carries an SF Symbol (`SessionType.symbolName`) shown on break rows; talk cards gain a stroked border in the session-type colour so type is conveyed by shape and border as well as fill.

**Reduce Motion.** Settings → Accessibility → Motion → Reduce Motion. Tap any favourite star — it must change state without bouncing. The code path is in `FavouriteButtonView.bounceIfMotionAllowed`.

### Accessibility Inspector audit

The Inspector ships with Xcode and runs against a booted simulator. From a terminal:

```bash
xcrun simctl boot 91E4D96A-5233-4166-9396-847DAA0C12B5   # any iPhone simulator UDID
open -a Simulator
xcodebuild -project MythConf/MythConf26.xcodeproj -scheme MythConf26 \
  -destination 'id=91E4D96A-5233-4166-9396-847DAA0C12B5' \
  -derivedDataPath /tmp/mythconf-dd build CODE_SIGNING_ALLOWED=NO
xcrun simctl install booted /tmp/mythconf-dd/Build/Products/Debug-iphonesimulator/MythConf26.app
xcrun simctl launch booted cjp.com.MythConf26
open -a "Accessibility Inspector"
```

In Accessibility Inspector: pick the booted simulator from the top-left target selector → click the **Audit** tab → **Run Audit** → record any warnings against the relevant row above. Navigate to the next screen in the simulator and re-run; the Inspector audits only the currently visible view tree.

### Dynamic Type at AX5

On a device: Settings → Accessibility → Display & Text Size → Larger Text → toggle on Larger Accessibility Sizes → drag the slider to the rightmost notch.

On the simulator:

```bash
xcrun simctl ui 91E4D96A-5233-4166-9396-847DAA0C12B5 content_size accessibility-extra-extra-extra-large
# reset afterwards:
xcrun simctl ui 91E4D96A-5233-4166-9396-847DAA0C12B5 content_size large
```

Re-launch the app and walk each screen. Pass criteria: no meaning-bearing text truncated, no controls pushed off-screen, layouts reflow vertically. Tab bar items and inline navigation titles intentionally cap their visible growth — long-press one and a centred HUD (the system **Large Content Viewer**) appears at full AX5 size.

### Differentiated haptics

Real device only — haptics do not fire in the simulator. Open Programme → tap a star to add (expect `.success`, a brief double-pulse) → tap the same star to remove (expect `.impact(weight: .light)`, a single soft thud). The pair should feel meaningfully different with your eyes closed.

### Automated counterpart

The five Tier 1 test suites in `MythConf26Tests/MythConf26Tests.swift` replicate what the Accessibility Inspector's audit checks at the data level — every spoken label is exercised against every talk, speaker, session and location in `conf.json` on every CI run. Running the manual Inspector audit is therefore a one-off confirmation rather than a recurring obligation.
