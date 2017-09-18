# git-utils

### who-moved-my-pointer.sh ###
utility for tracking changes in a submodule relative by commits in toplevel (parent)

./bin/who-moved-my-pointer.sh my-submodule

> f47bb34bbe1aa75a3fb9a9d0dd0ffd99134acb6a -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f ( Naftaly )
> 680c09ef34d8923db9bc3d914a7101d52e5a12c9 -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f ( Naftaly )
> 167e76cd2ccb7c9d729aeea4442eb72ea728d81c -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f ( Liran )
> d68c6b910787b2d7328fd39ff0200aaac0206ba2 -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f ( dror )
> 11e146e7b63f7281a903eb149379498beaf1aafc -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f ( Miky )



./bin/who-moved-my-pointer.sh my-submodule f47bb34bbe1aa75a3fb9a9d0dd0ffd99134acb6a 680c09ef34d8923db9bc3d914a7101d52e5a12c9

> xxxx

> c491a399f0d3db7570d8076b1661e7ce8389575e -> 0e2731c7684373e2ecbda2f9b2b71bf310a1dae4
> 1744b9708a5d9397e6987ff716cc636c58cfd9f4 -> bbb0725968fd4c27fa1e8398184e7ce2750a2d8f
> Submodule js_source/shared/sf-common 0e2731c..bbb0725 (rewind):
>   add fetching categories without crud
>   Merge pull request #244 from SAManage/17417_Incident_recordType_to_array
>   Merge pull request #246 from SAManage/17347_displayCIPreview
>  Merge pull request #243 from SAManage/17348_CisSelectorSearch
>  =-----------------------------------------------------------
> diff --git a/__tests__/ItemsSelector/ItemsSelector.spec.js b/__tests__/ItemsSelector/ItemsSelector.spec.js
> --- a/__tests__/ItemsSelector/ItemsSelector.spec.js
> +++ b/__tests__/ItemsSelector/ItemsSelector.spec.js
> .
> .
> .
