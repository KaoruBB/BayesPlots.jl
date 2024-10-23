module BayesPlots

using KernelDensity
using Plots
using StatsPlots

export plot_posterior_density

function plot_posterior_density(
    post_smpl::Vector; bandwidth="default", is_mean::Bool=true, is_ci::Bool=true, kwargs...
)
    U = bandwidth == "default" ? kde(post_smpl) : kde(post_smpl, bandwidth=bandwidth)

    fig = plot(
        U,
        ylabel="density",
        label="posterior density",
        color=:black;
        kwargs...
    )

    if is_mean
        mean_post = mean(post_smpl)
        vline!(fig, [mean_post], color=:red, linestyle=:dash, label="Posterior Mean")
    end

    if is_ci
        quantiles = quantile(post_smpl, [0.025, 0.975])
        qrange = quantiles[1]:0.01:quantiles[2]
        fig = plot!(
            fig,
            qrange, pdf(U, qrange),
            fill = (0, 0.3, :red),
            label = "95% CI",
        )
    end

    return fig
end

function plot_posterior_density(
    post_smpl::Matrix, name_params::Vector;
    bandwidth="default",
    is_mean::Bool=true,
    is_ci::Bool=true,
    kwargs...
)
    fig = plot(
        map(1:size(post_smpl, 2)) do i
            plot_posterior_density(
                post_smpl[:, i],
                bandwidth=bandwidth,
                is_mean=is_mean,
                is_ci=is_ci,
                xlabel=name_params[i],
            )
        end...;
        kwargs...
    )

    return fig
end


end
