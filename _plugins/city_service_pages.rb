# _plugins/city_service_pages.rb
#
# Generates /service-areas/{city-slug}/{service-slug}/ pages
# for every combination of city and service defined below.
#
# Output URL example:
#   /service-areas/mount-dora-fl/transmission-repair/
#
# ⚠️  GitHub Pages blocks custom plugins.
#     Use Netlify / Cloudflare Pages, OR run `jekyll build` locally
#     and commit the _site output to a gh-pages branch instead.

module RJFox
  class CityServicePageGenerator < Jekyll::Generator
    safe true
    priority :normal

    # ── CITIES ──────────────────────────────────────────────────────────────
    CITIES = [
      { name: "Mount Dora, FL",  slug: "mount-dora-fl",  distance: "less than ten minutes from downtown Mount Dora via US-441" },
      { name: "Tavares, FL",     slug: "tavares-fl",      distance: "just a short drive from Tavares on US-441"                },
      { name: "Leesburg, FL",    slug: "leesburg-fl",     distance: "conveniently located for Leesburg drivers on US-441"      },
      { name: "Clermont, FL",    slug: "clermont-fl",     distance: "an easy drive from Clermont via US-27 to US-441"          },
    ].freeze

    # ── SERVICES ─────────────────────────────────────────────────────────────
    SERVICES = [
      { title: "Transmission Repair",            slug: "transmission-repair",            icon: "fa-gears"        },
      { title: "Transmission Replacement",       slug: "transmission-replacement",       icon: "fa-rotate"       },
      { title: "Transmission Rebuild",           slug: "transmission-rebuild",           icon: "fa-screwdriver-wrench" },
      { title: "Transmission Maintenance",       slug: "transmission-maintenance",       icon: "fa-oil-can"      },
      { title: "Transmission Flush",             slug: "transmission-flush",             icon: "fa-droplet"      },
      { title: "Automatic Transmission Service", slug: "automatic-transmission-service", icon: "fa-sliders"      },
      { title: "CVT Transmission Service",       slug: "cvt-transmission-service",       icon: "fa-circle-nodes" },
      { title: "Clutch Repair",                  slug: "clutch-repair",                  icon: "fa-circle-dot"   },
      { title: "Engine Repair",                  slug: "engine-repair",                  icon: "fa-screwdriver-wrench" },
      { title: "Engine Rebuild",                 slug: "engine-rebuild",                 icon: "fa-engine"       },
      { title: "Engine Replacement",             slug: "engine-replacement",             icon: "fa-rotate"       },
      { title: "Auto Engine Diagnostic",         slug: "auto-engine-diagnostic",         icon: "fa-magnifying-glass" },
      { title: "Check Engine Light",             slug: "check-engine-light",             icon: "fa-triangle-exclamation" },
      { title: "AC Installation & Repair",       slug: "ac-installation-repair",         icon: "fa-snowflake"    },
      { title: "Auto Electrical Repair",         slug: "auto-electrical-repair",         icon: "fa-bolt"         },
      { title: "Diesel Engines",                 slug: "diesel-engines",                 icon: "fa-truck"        },
      { title: "Auto Brake Repair",              slug: "auto-brake-repair",              icon: "fa-circle-stop"  },
      { title: "Steering & Suspension Repair",   slug: "steering-suspension-repair",     icon: "fa-car-side"     },
      { title: "Wheel Alignment",                slug: "wheel-alignment",                icon: "fa-circle-dot"   },
      { title: "ADAS Calibration",               slug: "adas-calibration",               icon: "fa-camera"       },
    ].freeze

    def generate(site)
      CITIES.each do |city|
        SERVICES.each do |service|
          site.pages << CityServicePage.new(site, city, service)
        end
      end
    end
  end

  # ── PAGE CLASS ──────────────────────────────────────────────────────────────
  class CityServicePage < Jekyll::Page
    def initialize(site, city, service)
      @site = site
      @base = site.source
      @dir  = File.join("service-areas", city[:slug], service[:slug])
      @name = "index.html"

      self.process(@name)

      self.data = {
        "layout"           => "areas",
        "title"            => "#{service[:title]} Near #{city[:name]}",
        "city"             => city[:name],
        "city_slug"        => city[:slug],
        "service_title"    => service[:title],
        "service_slug"     => service[:slug],
        "service_icon"     => service[:icon],
        "hero_image"       => "/Pics/Hero.webp",
        "hero_sub"         => "#{service[:title]} for #{city[:name]} drivers. " \
                              "RJ Fox Automotive is located in Eustis, #{city[:distance]}. " \
                              "All makes and models. Honest pricing.",
        "meta_description" => "#{service[:title]} near #{city[:name]}. " \
                              "RJ Fox Automotive in Eustis serves #{city[:name]} drivers with " \
                              "honest estimates and fast turnaround. Call (352) 250-3210.",
        "cta_heading"      => "Serving #{city[:name]}",
        "cta_body"         => "#{city[:distance].capitalize}. Honest estimates before any work begins.",
        "generated"        => true,
      }

      # Build the page body
      self.content = build_content(city, service)
    end

    private

    def build_content(city, service)
      <<~HTML
        <h2>#{service[:title]} for #{city[:name]} Drivers</h2>

        <p>RJ Fox Automotive is the shop that #{city[:name]} drivers trust for honest, accurate #{service[:title].downcase}
        on all makes and models. We are located at 801 David Walker Dr in Eustis &mdash; #{city[:distance]}.
        Whether you drive a daily commuter, a diesel truck, or a high-mileage vehicle that needs attention,
        we diagnose it accurately, give you a straight written estimate, and fix it right the first time.</p>

        <p>We do not replace parts by process of elimination. Every job starts with an accurate diagnosis,
        and you will always know exactly what we found and what it costs before we touch anything.</p>

        <h2>Why #{city[:name]} Customers Choose RJ Fox</h2>

        <p><strong>Transmission work stays in-house.</strong> Most shops send transmission jobs to an outside rebuilder.
        We do it here. Rob has over 20 years of hands-on transmission experience covering automatic, manual, CVT,
        and clutch systems &mdash; which means better quality control and no middleman markup.</p>

        <p><strong>We work on everything.</strong> Domestic trucks, Japanese imports, European vehicles, diesel-powered
        trucks, and newer vehicles with complex electronics. We have factory-level diagnostic equipment and
        the experience to use it.</p>

        <p><strong>Honest pricing, every time.</strong> You will never be handed a bill that does not match
        what was discussed. We call you if anything changes during the repair before we proceed.</p>

        <figure class="sp-photo">
          <img src="/Pics/RJ9.webp" alt="RJ Fox Automotive shop in Eustis FL serving #{city[:name]}">
          <figcaption>RJ Fox Automotive at 801 David Walker Dr in Eustis &mdash; serving #{city[:name]} and all of Lake County.</figcaption>
        </figure>

        <h2>Schedule #{service[:title]} Near #{city[:name]}</h2>

        <p>Call us at (352) 250-3210 or stop by the shop. We are open Monday through Friday 8am&ndash;6pm
        and Saturday 8am&ndash;2pm. No appointment necessary, though calling ahead helps us prepare for your vehicle.</p>

        <div class="ar-services">
          <div class="ar-services__grid">
            <a href="/services/transmission-repair/" class="ar-services__item"><i class="fa-solid fa-gears"></i> Transmission Repair</a>
            <a href="/services/transmission-replacement/" class="ar-services__item"><i class="fa-solid fa-rotate"></i> Transmission Replacement</a>
            <a href="/services/transmission-maintenance/" class="ar-services__item"><i class="fa-solid fa-oil-can"></i> Transmission Maintenance</a>
            <a href="/services/transmission-flush/" class="ar-services__item"><i class="fa-solid fa-droplet"></i> Transmission Flush</a>
            <a href="/services/automatic-transmission-service/" class="ar-services__item"><i class="fa-solid fa-sliders"></i> Automatic Transmission Service</a>
            <a href="/services/cvt-transmission-service/" class="ar-services__item"><i class="fa-solid fa-circle-nodes"></i> CVT Transmission Service</a>
            <a href="/services/clutch-repair/" class="ar-services__item"><i class="fa-solid fa-circle-dot"></i> Clutch Repair</a>
            <a href="/services/engine-repair/" class="ar-services__item"><i class="fa-solid fa-screwdriver-wrench"></i> Engine Repair</a>
            <a href="/services/engine-rebuild/" class="ar-services__item"><i class="fa-solid fa-engine"></i> Engine Rebuild</a>
            <a href="/services/ac-installation-repair/" class="ar-services__item"><i class="fa-solid fa-snowflake"></i> AC Repair</a>
            <a href="/services/auto-brake-repair/" class="ar-services__item"><i class="fa-solid fa-circle-stop"></i> Brake Repair</a>
            <a href="/services/auto-electrical-repair/" class="ar-services__item"><i class="fa-solid fa-bolt"></i> Electrical Repair</a>
            <a href="/services/diesel-engines/" class="ar-services__item"><i class="fa-solid fa-truck"></i> Diesel Engines</a>
            <a href="/services/steering-suspension-repair/" class="ar-services__item"><i class="fa-solid fa-car-side"></i> Steering &amp; Suspension</a>
            <a href="/services/wheel-alignment/" class="ar-services__item"><i class="fa-solid fa-circle-dot"></i> Wheel Alignment</a>
            <a href="/services/adas-calibration/" class="ar-services__item"><i class="fa-solid fa-camera"></i> ADAS Calibration</a>
          </div>
        </div>
      HTML
    end
  end
end
