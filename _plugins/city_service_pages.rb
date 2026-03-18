module RJFox
  class CityServicePageGenerator < Jekyll::Generator
    safe true
    priority :normal

    # Icon map: service slug → Font Awesome class
    # Used as a fallback if the YML entry doesn't supply its own icon.
    SERVICE_ICONS = {
      "transmission-repair"            => "fa-gears",
      "transmission-replacement"       => "fa-rotate",
      "transmission-rebuild"           => "fa-screwdriver-wrench",
      "transmission-maintenance"       => "fa-oil-can",
      "transmission-flush"             => "fa-droplet",
      "automatic-transmission-service" => "fa-sliders",
      "cvt-transmission-service"       => "fa-circle-nodes",
      "clutch-repair"                  => "fa-circle-dot",
      "engine-repair"                  => "fa-screwdriver-wrench",
      "engine-rebuild"                 => "fa-engine",
      "engine-replacement"             => "fa-rotate",
      "auto-engine-diagnostic"         => "fa-magnifying-glass",
      "check-engine-light"             => "fa-triangle-exclamation",
      "ac-installation-repair"         => "fa-snowflake",
      "auto-electrical-repair"         => "fa-bolt",
      "diesel-engines"                 => "fa-truck",
      "auto-brake-repair"              => "fa-circle-stop",
      "steering-suspension-repair"     => "fa-car-side",
      "wheel-alignment"                => "fa-circle-dot",
      "adas-calibration"               => "fa-camera",
      "general-repairs-maintenance"    => "fa-wrench",
    }.freeze

    def generate(site)
      areas = site.data["service-areas"]

      unless areas.is_a?(Array)
        Jekyll.logger.warn "CityServicePages:",
          "_data/service-areas.yml not found or not an array — no pages generated."
        return
      end

      count = 0

      areas.each do |area|
        city_slug = area["slug"]
        city_name = area["name"]

        unless city_slug && city_name
          Jekyll.logger.warn "CityServicePages:",
            "Skipping area entry missing slug or name: #{area.inspect}"
          next
        end

        services = area["services"]

        unless services.is_a?(Array) && services.any?
          Jekyll.logger.warn "CityServicePages:",
            "No services array for #{city_name} — skipping."
          next
        end

        services.each do |svc|
          svc_slug = svc["slug"]
          svc_name = svc["name"]

          unless svc_slug && svc_name
            Jekyll.logger.warn "CityServicePages:",
              "Skipping service in #{city_name} missing slug or name: #{svc.inspect}"
            next
          end

          site.pages << CityServicePage.new(site, area, svc)
          count += 1
        end
      end

      Jekyll.logger.info "CityServicePages:", "Generated #{count} service-area pages."
    end
  end

  # ── PAGE CLASS ──────────────────────────────────────────────────────────────
  class CityServicePage < Jekyll::Page
    def initialize(site, area, svc)
      @site = site
      @base = site.source
      @dir  = File.join("service-areas", area["slug"], svc["slug"])
      @name = "index.html"

      self.process(@name)

      icon = svc["icon"] ||
             CityServicePageGenerator::SERVICE_ICONS[svc["slug"]] ||
             "fa-wrench"

      # hero_sub falls back to a generic string if not set in YML
      hero_sub = svc["hero_sub"] ||
                 "#{svc["name"]} for #{area["name"]} drivers. " \
                 "RJ Fox Automotive is in Eustis — #{area["drive"] || "a short drive away"}. " \
                 "All makes and models. Honest pricing."

      self.data = {
        # ── Required by layout ──────────────────────────────
        "layout"        => "service-areas",
        "city_slug"     => area["slug"],
        "service_slug"  => svc["slug"],

        # ── SEO / <title> ───────────────────────────────────
        "title"         => "#{svc["name"]} Near #{area["name"]} | RJ Fox Automotive",

        # ── Convenience front-matter (used by layout) ───────
        "city"          => area["name"],
        "service_title" => svc["name"],
        "service_icon"  => icon,
        "hero_image"    => "/Pics/Hero.webp",
        "hero_sub"      => hero_sub,

        # ── Meta description ────────────────────────────────
        "description"   => "#{svc["name"]} near #{area["name"]}. " \
                           "RJ Fox Automotive in Eustis serves #{area["name"]} drivers — " \
                           "#{area["drive"] || "close by"}. Honest estimates. Call (352) 250-3210.",

        # ── Marker so you can filter these in Liquid if needed
        "generated"     => true,
      }
      
      self.content = svc["body"] || ""
    end
  end
end
