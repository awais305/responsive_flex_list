/// Defines responsive breakpoints and their corresponding column counts.
///
/// You can customize this globally with [ResponsiveFlexConfig.init]
/// or per-list by passing [breakpoints] directly.
class Breakpoints {
  static const Breakpoints defaultBreakpoints = Breakpoints(
    smallMobile: 320,
    mobile: 480,
    smallTablet: 640,
    tablet: 820,
    laptop: 1024,
    desktop: 1280,
    largeDesktop: 1440,
    extraLargeDesktop: 1920,
    smallMobileColumns: 1,
    mobileColumns: 2,
    smallTabletColumns: 3,
    tabletColumns: 4,
    laptopColumns: 5,
    desktopColumns: 6,
    largeDesktopColumns: 7,
    extraLargeDesktopColumns: 8,
  );

  /// Small mobile devices (e.g., older iPhones, < 320px).
  final double? smallMobile;

  /// Standard mobile devices (e.g., iPhone 12, Pixel, < 480px).
  final double? mobile;

  /// Small tablets (e.g., iPad Mini, < 640px).
  final double? smallTablet;

  /// Full tablets (e.g., iPad, < 820px).
  final double? tablet;

  /// Small laptops (e.g., MacBook Air 11", < 1024px).
  final double? laptop;

  /// Desktops (e.g., 13"–15" screens, < 1280px).
  final double? desktop;

  /// Large desktops (e.g., ultrawide monitors, < 1440px).
  final double? largeDesktop;

  /// Extra large desktops (e.g., 4K setups, < 1920px).
  final double? extraLargeDesktop;

  /// Number of columns for each breakpoint.
  final int smallMobileColumns;
  final int mobileColumns;
  final int smallTabletColumns;
  final int tabletColumns;
  final int laptopColumns;
  final int desktopColumns;
  final int largeDesktopColumns;
  final int extraLargeDesktopColumns;

  /// Creates a new [Breakpoints] configuration.
  ///
  /// All parameters are optional. If not provided, the default values
  /// will be used when merged with [defaultBreakpoints].
  const Breakpoints({
    this.smallMobile,
    this.mobile,
    this.smallTablet,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
    this.extraLargeDesktop,
    this.smallMobileColumns = 1,
    this.mobileColumns = 2,
    this.smallTabletColumns = 3,
    this.tabletColumns = 4,
    this.laptopColumns = 5,
    this.desktopColumns = 6,
    this.largeDesktopColumns = 7,
    this.extraLargeDesktopColumns = 8,
  }) : assert(
         smallMobileColumns > 0 &&
             mobileColumns > 0 &&
             smallTabletColumns > 0 &&
             tabletColumns > 0 &&
             laptopColumns > 0 &&
             desktopColumns > 0 &&
             largeDesktopColumns > 0 &&
             extraLargeDesktopColumns > 0,
         'Column counts must all be greater than zero',
       );

  /// Creates a copy of this [Breakpoints] with the given fields replaced
  /// with new values.
  ///
  /// This is useful for creating variations of existing breakpoint
  /// configurations without having to specify all values again.
  ///
  /// Example:
  /// ```dart
  /// final customBreakpoints = Breakpoints.defaultBreakpoints.copyWith(
  ///   tabletColumns: 4,
  ///   laptopColumns: 5,
  /// );
  /// ```
  Breakpoints copyWith({
    double? smallMobile,
    double? mobile,
    double? smallTablet,
    double? tablet,
    double? laptop,
    double? desktop,
    double? largeDesktop,
    int? smallMobileColumns,
    int? mobileColumns,
    int? smallTabletColumns,
    int? tabletColumns,
    int? laptopColumns,
    int? desktopColumns,
    int? largeDesktopColumns,
  }) => Breakpoints(
    smallMobile: smallMobile ?? this.smallMobile,
    mobile: mobile ?? this.mobile,
    smallTablet: smallTablet ?? this.smallTablet,
    tablet: tablet ?? this.tablet,
    laptop: laptop ?? this.laptop,
    desktop: desktop ?? this.desktop,
    largeDesktop: largeDesktop ?? this.largeDesktop,
    smallMobileColumns: smallMobileColumns ?? this.smallMobileColumns,
    mobileColumns: mobileColumns ?? this.mobileColumns,
    smallTabletColumns: smallTabletColumns ?? this.smallTabletColumns,
    tabletColumns: tabletColumns ?? this.tabletColumns,
    laptopColumns: laptopColumns ?? this.laptopColumns,
    desktopColumns: desktopColumns ?? this.desktopColumns,
    largeDesktopColumns: largeDesktopColumns ?? this.largeDesktopColumns,
  );

  /// Merges this breakpoints configuration with another, using the other's
  /// non-null values to override this one's values.
  ///
  /// This is used internally to combine custom breakpoints with defaults.
  Breakpoints mergeWith(Breakpoints? other) {
    if (other == null) return this;

    return Breakpoints(
      smallMobile: other.smallMobile ?? smallMobile,
      mobile: other.mobile ?? mobile,
      smallTablet: other.smallTablet ?? smallTablet,
      tablet: other.tablet ?? tablet,
      laptop: other.laptop ?? laptop,
      desktop: other.desktop ?? desktop,
      largeDesktop: other.largeDesktop ?? largeDesktop,
      smallMobileColumns: other.smallMobileColumns,
      mobileColumns: other.mobileColumns,
      smallTabletColumns: other.smallTabletColumns,
      tabletColumns: other.tabletColumns,
      laptopColumns: other.laptopColumns,
      desktopColumns: other.desktopColumns,
      largeDesktopColumns: other.largeDesktopColumns,
    );
  }

  /// Creates a Breakpoints instance where *only* the specified
  /// values are kept. Everything else defaults to null.
  factory Breakpoints.onlyWith({
    double? smallMobile,
    int? smallMobileColumns,
    double? mobile,
    int? mobileColumns,
    double? smallTablet,
    int? smallTabletColumns,
    double? tablet,
    int? tabletColumns,
    double? laptop,
    int? laptopColumns,
    double? desktop,
    int? desktopColumns,
    double? largeDesktop,
    int? largeDesktopColumns,
    double? extraLargeDesktop,
    int? extraLargeDesktopColumns,
  }) => Breakpoints(
    smallMobile: smallMobile,
    smallMobileColumns: smallMobileColumns ?? 1,
    mobile: mobile,
    mobileColumns: mobileColumns ?? 1,
    smallTablet: smallTablet,
    smallTabletColumns: smallTabletColumns ?? 1,
    tablet: tablet,
    tabletColumns: tabletColumns ?? 1,
    laptop: laptop,
    laptopColumns: laptopColumns ?? 1,
    desktop: desktop,
    desktopColumns: desktopColumns ?? 1,
    largeDesktop: largeDesktop,
    largeDesktopColumns: largeDesktopColumns ?? 1,
    extraLargeDesktop: extraLargeDesktop,
    extraLargeDesktopColumns: extraLargeDesktopColumns ?? 1,
  );

  @override
  String toString() {
    return 'Breakpoints('
        'smallMobile: $smallMobile, '
        'mobile: $mobile, '
        'smallTablet: $smallTablet, '
        'tablet: $tablet, '
        'laptop: $laptop, '
        'desktop: $desktop, '
        'largeDesktop: $largeDesktop, '
        'smallMobileColumns: $smallMobileColumns, '
        'mobileColumns: $mobileColumns, '
        'smallTabletColumns: $smallTabletColumns, '
        'tabletColumns: $tabletColumns, '
        'laptopColumns: $laptopColumns, '
        'desktopColumns: $desktopColumns, '
        'largeDesktopColumns: $largeDesktopColumns'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Breakpoints) return false;

    return smallMobile == other.smallMobile &&
        mobile == other.mobile &&
        smallTablet == other.smallTablet &&
        tablet == other.tablet &&
        laptop == other.laptop &&
        desktop == other.desktop &&
        largeDesktop == other.largeDesktop &&
        smallMobileColumns == other.smallMobileColumns &&
        mobileColumns == other.mobileColumns &&
        smallTabletColumns == other.smallTabletColumns &&
        tabletColumns == other.tabletColumns &&
        laptopColumns == other.laptopColumns &&
        desktopColumns == other.desktopColumns &&
        largeDesktopColumns == other.largeDesktopColumns;
  }

  @override
  int get hashCode {
    return Object.hash(
      smallMobile,
      mobile,
      smallTablet,
      tablet,
      laptop,
      desktop,
      largeDesktop,
      smallMobileColumns,
      mobileColumns,
      smallTabletColumns,
      tabletColumns,
      laptopColumns,
      desktopColumns,
      largeDesktopColumns,
    );
  }
}
