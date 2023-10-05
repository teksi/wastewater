## How to use the continuous integration (CI)

### Error prompt

The place to look out for error messages in the CI (when they happen during the datamodel initialisation)  is here :

![image](https://user-images.githubusercontent.com/1894106/221143200-e27f17ed-2c3a-48b8-84c3-c01ac8275559.png)

In this specific case, you will see:
```
     [many many more output lines above]
     Applying delta 1.4.0 swmm_views... OK
     Applying delta 1.4.0 update_wastewater_structure_label_with_bottom_level... OK
     Applying delta 1.4.1 swmm_catchment_areas... OK
     Applying delta 1.5.0 fix_network_tracking_views... OK
     Applying delta 1.5.0 labelling... OK
     Applying delta 1.5.1 fix_network_tracking_views... OK
     Applying delta 1.5.2 fix_network_tracking_views... OK
     Applying delta 1.5.3 fix_symbology_function... OK
     Applying delta 1.5.3 fix_vl_value_en_digital_video... OK
     Applying delta 1.5.3 fix_ws_output_labels... OK
     Applying delta 1.5.5 add_spatial_index_on_network_views... OK
     Applying delta 1.5.5 fix_dictionary_od_table_datenlieferant... OK
     Applying delta 1.5.5 fix_permissions_on_network_refresh_function... OK
     Applying delta 1.5.5 symbology_for_nodes... OK
     Applying delta 1.5.6 kek_model_update_2008_2019... OK
     Applying delta 1.5.7 add_status_to_wn... syntax error at or near "FUNCTION"
LINE 38:     EXECUTE FUNCTION qgep_od.ft_vw_wastewater_node_delete();
```

And this can be done locally too (with Docker) by doing the same steps done in https://github.com/QGEP/datamodel/blob/master/.github/workflows/docker-test-and-push.yaml#L44-L48.
```bash
# build dockerfile
docker build -f .docker/Dockerfile --build-arg POSTGIS_VERSION=11-3.2 --tag qgep_img .

# initialize qgep container (without -d so it runs in foreground)
docker run -it -p 5432:5432 --name qgep qgep_img
```
