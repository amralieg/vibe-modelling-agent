#!/usr/bin/env python3
import json
import sys
from pathlib import Path


GLOBAL_COLLECTION_VOLUME = "/Volumes/_root/default/root_vol"


SECTOR_MAP = [
    ("agriculture",
     "Agriculture",
     ["Agriculture"]),
    ("real_estate_and_professional_services",
     "Real Estate & Professional Services",
     ["Real Estate", "Staffing HR"]),
    ("financial_services",
     "Financial Services",
     ["Banking", "Payments Fintech", "Health Insurance", "Life Insurance"]),
    ("healthcare_and_life_sciences",
     "Healthcare & Life Sciences",
     ["Healthcare", "Pharmaceuticals", "Genomics Biotech", "Clinical Trials"]),
    ("energy_and_utilities",
     "Energy & Utilities",
     ["Oil Gas", "Energy Utilities", "Mining", "Water Utilities"]),
    ("travel_transport_logistics",
     "Travel, Transport & Logistics",
     ["Airlines", "Travel Hospitality", "Transport Shipping", "Shipping Ports"]),
    ("public_sector_education_nonprofit",
     "Public Sector, Education & Non-Profit",
     ["Education", "NGO", "Legal", "Waste Management"]),
    ("communications_media_entertainment",
     "Communications, Media & Entertainment",
     ["Telecommunication", "Media Broadcasting", "Sports Entertainment", "Gaming", "Advertising"]),
    ("manufacturing",
     "Manufacturing",
     ["Manufacturing", "Chemical Mfg", "Semiconductors", "Automotive", "Construction"]),
    ("retail_and_consumer_goods",
     "Retail & Consumer Goods",
     ["Retail", "Grocery", "Ecommerce", "Consumer Goods", "Apparel Fashion", "Food Beverage", "Restaurants"]),
]


def load_source(here):
    src_path = here.parent / "all-industries.json"
    if not src_path.exists():
        print(f"FATAL: {src_path} not found", file=sys.stderr)
        sys.exit(1)
    return json.loads(src_path.read_text())


def validate_coverage(src_businesses_by_name):
    expected = []
    for slug, _label, names in SECTOR_MAP:
        for n in names:
            if n not in src_businesses_by_name:
                print(f"FATAL: sector '{slug}' references unknown industry '{n}'", file=sys.stderr)
                sys.exit(1)
            expected.append(n)
    if len(expected) != 40:
        print(f"FATAL: SECTOR_MAP covers {len(expected)} industries, expected 40", file=sys.stderr)
        sys.exit(1)
    if sorted(expected) != sorted(src_businesses_by_name.keys()):
        missing = set(src_businesses_by_name.keys()) - set(expected)
        extra = set(expected) - set(src_businesses_by_name.keys())
        print(f"FATAL: SECTOR_MAP coverage mismatch missing={missing} extra={extra}", file=sys.stderr)
        sys.exit(1)


def build_widget_values(src_widget_values):
    out = dict(src_widget_values)
    out["global_collection_volume"] = GLOBAL_COLLECTION_VOLUME
    return out


def emit_sector_files(here, target_widget_values, src_businesses_by_name):
    written = []
    for slug, _label, names in SECTOR_MAP:
        payload = {
            "widget_values": target_widget_values,
            "businesses": [
                {
                    "name": n,
                    "description": src_businesses_by_name[n]["description"],
                    "model_vibes": "",
                }
                for n in names
            ],
        }
        out_path = here / f"{slug}.json"
        out_path.write_text(json.dumps(payload, indent=2) + "\n")
        written.append((slug, len(names), out_path))
        print(f"wrote {out_path.name} ({len(names)} industries)")
    return written


def main():
    here = Path(__file__).resolve().parent
    src = load_source(here)
    src_businesses_by_name = {b["name"]: b for b in src["businesses"]}
    if len(src["businesses"]) != 40:
        print(f"FATAL: all-industries.json has {len(src['businesses'])} businesses, expected 40", file=sys.stderr)
        sys.exit(1)
    validate_coverage(src_businesses_by_name)
    target_widget_values = build_widget_values(src["widget_values"])
    written = emit_sector_files(here, target_widget_values, src_businesses_by_name)
    total = sum(n for _slug, n, _p in written)
    print(f"OK: {len(written)} sector files, {total} industries total")


if __name__ == "__main__":
    main()
