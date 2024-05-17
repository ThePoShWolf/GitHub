filter Get-GitHubOrganizationMembers {
    <#
        .SYNOPSIS
        List organization members

        .DESCRIPTION
        Requires an organization slug to be passed, will return all members for that organization.

        .EXAMPLE
        Get-GitHubOrganizationMembers -OrganizationName 'PSModule'

        List organizations for the PSModule organization.

        .NOTES
        [List organization members](https://docs.github.com/en/rest/orgs/members)
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param (
        # The organization name. The name is not case sensitive.
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [Alias('login')]
        [Alias('org')]
        [Alias('owner')]
        [string] $OrganizationName,

        # The number of results per page (max 100).
        [ValidateRange(1, 100)]
        [int] $PerPage = 30
    )

    $body = @{
        per_page = $PerPage
    }

    $inputObject = @{
        APIEndpoint = "/orgs/$OrganizationName/members"
        Method      = 'GET'
        Body        = $body
    }

    Invoke-GitHubAPI @inputObject | ForEach-Object {
        Write-Output $_.Response
    }
}
